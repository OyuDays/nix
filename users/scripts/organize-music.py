from pathlib import Path
import shutil
import os
import sys
import itertools
import json
import mutagen
import argparse
from mutagen.flac import FLAC
from mutagen.oggopus import OggOpus
from mutagen.mp3 import MP3


class ParsedSong:
	def __init__(
		self,
		song,
		src_path: Path,
		file_ext: str,
		album: ParsedAlbum,
		title: str,
		artist: str,
		artists: list,
		track_nr: int,
		disc_nr: int,
	):
		self.song = song
		self.src_path = src_path
		self.file_ext = file_ext
		self.album = album
		self.title = title
		self.artist = artist
		self.artists = artists
		self.track_nr = track_nr
		self.disc_nr = disc_nr

	def get_file_name(self):
		filename = ""
		if self.album.total_discs is not None and self.album.total_discs > 1:
			filename += f"{self.disc_nr}."
		
		if self.track_nr is not None and (self.album.total_tracks is None or self.album.total_tracks > 1):
			filename += f"{self.track_nr:02}. "

		filename += f"{self.title}.{self.file_ext}"

		return filename

class ParsedAlbum:
	def __init__(
		self,
		album_name: str,
		album_id: str,
		release_date: str,
		album_artist: str,
		album_artists: list,
		total_tracks: int,
		total_discs: int,
		region: str
	):
		self.album_name = album_name
		self.album_id = album_id
		self.release_date = release_date
		self.album_artist = album_artist
		self.album_artists = album_artists
		self.total_tracks = total_tracks
		self.total_discs = total_discs
		self.region = region
		self.songs = []

		self.deduplicated_name = None

		self.key = f"{self.album_name}_a_{self.album_artist}"
		if self.album_id is not None:
			self.key = self.album_id
		else:
			self.key = f"{self.album_name}_a_{self.album_artist}"
			if self.total_tracks is not None:
				self.key += f"_tt_{self.total_tracks}"
			if self.total_discs is not None:
				self.key += f"_td_{self.total_discs}"
			if self.release_date is not None:
				self.key += f"_r_{self.release_date}"

	def add_song(self, song: ParsedSong):
		self.songs.append(song)

	def get_artist_directory(self):
		if self.album_artist == "Various Artists":
			return self.album_artist

		dirname = self.album_artist
		if self.album_artists is not None and len(self.album_artists) > 0:
			dirname = self.album_artists[0]
#		else:
#			artist_frequencies = {}
#			for song in self.songs:
#				if song.artists is not None and len(song.artists) > 0:
#					artist = song.artists[0]
#					if artist in artist_frequencies:
#						artist_frequencies[artist] += 1
#					else:
#						artist_frequencies[artist] = 0
#			
#			highest_count = 0
#			highest_artist = None
#			for artist, count in artist_frequencies.items():
#				if count > highest_count:
#					highest_count = count
#					highest_artist = artist
#
#			if highest_artist is not None:
#				dirname = artist
		return dirname

	def get_album_directory(self):
		return self.deduplicated_name if self.deduplicated_name is not None else self.album_name



def song_has_required_tags(song, file: Path, tags: list) -> bool:
	missing = []
	for tag in tags:
		if tag not in song:
			missing.append(tag)

	if len(missing) == 0:
		return True


	print(f"song {file} missing required tags: {', '.join(missing)}")
	return False



def get_albums(src_dir: Path) -> list:

	albums = {}
	for file in itertools.chain(src_dir.rglob('*.flac'), src_dir.rglob('*.opus'), src_dir.rglob('*.mp3')):
		song = mutagen.File(file)
		file_ext = None
		if type(song) is FLAC:
			file_ext = "flac"
		elif type(song) is OggOpus:
			file_ext = "opus"
		elif type(song) is MP3:
			file_ext = "mp3"

		if file_ext is None:
			print(f"failed to parse music file {file}, skipping")
			continue

		if not song_has_required_tags(song, file, [ "title", "album", "artist", "albumartist" ]):
			continue

		title = song["title"][0]
		title = title.replace('/', '⁄')

		album = song["album"][0]


		artist = song["artist"][0]

		artists = None
		if "artists" in song:
			artists = song["artists"]


		album_artist = song["albumartist"][0]
		
		album_artists = None
		if "albumartists" in song:
			album_artists = song["albumartists"]

		total_discs = 1
		if "totaldiscs" in song:
			total_discs = int(song["totaldiscs"][0])
		disc_number = 1
		if "discnumber" in song:
			disc_number = int(song["discnumber"][0])
		total_tracks = None
		if "totaltracks" in song:
			total_tracks = int(song["totaltracks"][0])
		track_number = None
		if "tracknumber" in song:
			track_number = int(song["tracknumber"][0])

		release_country = None
		if "releasecountry" in song:
			release_country = song["releasecountry"][0]

		date = None
		if "date" in song:
			date = song["date"][0]

		album_id = None
		if "musicbrainz_albumid" in song:
			album_id = song["musicbrainz_albumid"][0]

		parsed_album = ParsedAlbum(
			album_name=album,
			album_id=album_id,
			release_date=date,
			album_artist=album_artist,
			album_artists=album_artists,
			total_tracks=total_tracks,
			total_discs=total_discs,
			region=release_country
		)

		album_key = parsed_album.key

		if album_key in albums:
			parsed_album = albums[album_key]
		else:
			albums[album_key] = parsed_album
		
		parsed_song = ParsedSong(
			song=song,
			src_path=file,
			file_ext=file_ext,
			album=parsed_album,
			title=title,
			artist=artist,
			artists=artists,
			track_nr=track_number,
			disc_nr=disc_number
		)

		parsed_album.add_song(parsed_song)
		
	return albums.values()


def resolve_duplicates(albums: list) -> int:
	unresolved_duplicates = 0
	album_set = {}
	for album in albums:
		if album.album_name in album_set:
			other_album = album_set[album.album_name]
			if album.region != other_album.region:
				other_album.deduplicated_name = f"{other_album.album_name} ({other_album.region})"
				album.deduplicated_name = f"{album.album_name} ({album.region})"
			else:
				other_album.deduplicated_name = f"{other_album.album_name} ({other_album.release_date})"
				album.deduplicated_name = f"{album.album_name} ({album.release_date})"

			if other_album.deduplicated_name == album.deduplicated_name:
				unresolved_duplicates += 1
				print(f"unresolved duplicate: {album.album_artist - album.album_name}")
		else:
			album_set[album.album_name] = album

	return unresolved_duplicates



def organize(src_dir: Path, dst_dir: Path, albums: list, copy: bool, verbose: bool, dry_run: bool) -> tuple[int, dict]:
	songs_skipped = 0
	remaps = {}
	for album in albums:

		album_dir = f"{dst_dir}/{album.get_artist_directory()}/{album.get_album_directory()}/"
		
		for song in album.songs:

			filename = song.get_file_name()
			new_path = Path(f"{album_dir}/{filename}").resolve()

			if song.src_path == new_path and not dry_run:
				print(f"skipping {artist} - {title}")
				songs_skipped += 1
				continue

			if new_path.exists() and not dry_run:
				print(f"skipping {new_path}, file exists")
				songs_skipped += 1
				continue



			if not dry_run:
				new_path.parent.mkdir(parents=True, exist_ok=True)
			
				if copy:
					shutil.copy2(song.src_path, new_path)
					#song.src_path.move(new_path)
				else:
					shutil.move(song.src_path, new_path)
					#song.src_path.copy(new_path, preserve_metadata=True)

			src_relative = song.src_path.relative_to(src_dir)
			dst_relative = new_path.relative_to(dst_dir)
			if src_relative != dst_relative:
				remaps[str(src_relative)] = str(dst_relative)

			if verbose:
				print(f"{song.src_path} -> {new_path}") 

	if songs_skipped != 0:
		print(f"{songs_skipped} were skipped, check the log for more detail")

	for root, dirs, files in src_dir.walk(top_down=False):
		if not root.exists():
			continue

		if len(list(root.iterdir())) == 0 and not dry_run:
			root.rmdir()

	if not copy and not dry_run and src_dir.exists():
		print(f"files remain in {src_dir}")

	return songs_skipped, remaps


def organizer_run(args) -> int:

	dry_run = args.dry_run
	verbose = args.verbose


	remap_file_path = None
	if args.remap_file is not None:
		path = Path(args.remap_file).resolve()
		if path.is_dir():
			remap_file_path = Path(f"{path}/remap.json")
		elif not path.parent.exists():
			print(f"parent directory of {path} doesn't exist")
			return -1
		else:
			remap_file_path = path

		if remap_file_path.exists():
			print(f"can't output remap file to {remap_file_path}, file exists")
			return -1


	src_dir = Path(args.source).resolve()
	if not src_dir.exists():
		print(f"{src_dir.parent} doesn't exist")
		return -1

	dst_dir = Path(args.destination).resolve()
	if not dst_dir.exists():
		if not dst_dir.parent.exists():
			print(f"{dst_dir} doesn't exist")
			return -1
		if not dry_run:
			dst_dir.mkdir()

	if src_dir.is_relative_to(dst_dir):
		tmp_src_dir = Path(f"{src_dir}.found").resolve()
		if tmp_src_dir.exists():
			print(f"couldnt create temp dir")
			return -1
		if not dry_run:
			src_dir = src_dir.rename(tmp_src_dir)


	albums = get_albums(src_dir)
	print(f"found {len(albums)} albums")
	unresolved_duplicates = resolve_duplicates(albums)
	if unresolved_duplicates != 0 and not args.force:
		printf(f"failed to resolve {unresolved_duplicates} duplicates. use --force continue regardless")
		return -1

	skipped, remaps = organize(src_dir, dst_dir, albums, copy=not args.delete, verbose=verbose, dry_run=dry_run)
	print(f"successfully moved {len(remaps)} files{f", and skipped {skipped} for fun" if skipped > 0 else ""}")

	if remap_file_path is not None:
		if len(remaps) == 0:
			print(f"skipping writing remap file, no paths were changed")
		else:
			with open(remap_file_path, "w") as file:
				file.write(json.dumps(remaps, indent=2, ensure_ascii=False))



def check_run(args) -> int:
	library_dir = Path(args.library)
	if not library_dir.exists():
		print(f"library directory {library_dir} does not exist")
		return -1

	albums = get_albums(library_dir)

	for album in albums:
		for song in album.songs:
			if hasattr(song.song, "pictures") and len(song.song.pictures) == 0:
				print(f"song {song.src_path} has no embedded images")

	return 0

def main() -> int:
	parser = argparse.ArgumentParser(
		prog="libmgr",
		description="manager of song library",
		epilog="hi",
	)

	subparsers = parser.add_subparsers(help="functions")

	organize_parser = subparsers.add_parser("organize", help="organize the library based on song and album metadata")
	organize_parser.add_argument("source")
	organize_parser.add_argument("destination")
	organize_parser.add_argument("-d", "--delete", action="store_true", help="delete source files")
	organize_parser.add_argument("-v", "--verbose", action="store_true", help="yap")
	organize_parser.add_argument("-r", "--remap-file", help="the path to which to output the remap file")
	organize_parser.add_argument("-f", "--force", action="store_true", help="ignore errors")
	organize_parser.add_argument("--dry-run", action="store_true", help="do nothing")
	organize_parser.set_defaults(func=organizer_run)


	check_parser = subparsers.add_parser("check", help="check for errors in the library")
	check_parser.add_argument("library", help="the library directory")
	check_parser.set_defaults(func=check_run)

	args = parser.parse_args()

	return args.func(args)



if __name__ == "__main__":
	exit_code = main()
	exit(exit_code)