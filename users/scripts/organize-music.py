from pathlib import Path
import shutil
import os
import sys
import itertools
import mutagen
from mutagen.flac import FLAC
from mutagen.oggopus import OggOpus
from mutagen.mp3 import MP3
import argparse


class ParsedSong:
	def __init__(
		self,
		src_path: Path,
		file_ext: str,
		album: ParsedAlbum,
		title: str,
		artist: str,
		artists: list,
		track_nr: int,
		disc_nr: int,
	):
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
		total_discs: int
	):
		self.album_name = album_name
		self.album_id = album_id
		self.release_date = release_date
		self.album_artist = album_artist
		self.album_artists = album_artists
		self.total_tracks = total_tracks
		self.total_discs = total_discs
		self.songs = []

		self.deduplicated_name = None

		self.key = f"{self.album_name}_a_{album_artist}"
		if self.album_id is not None:
			self.key = self.album_id
		else:
			self.key = f"{self.album_name}_a_{album_artist}"
			if self.total_tracks is not None:
				self.key += f"_tt_{total_tracks}"
			if self.total_discs is not None:
				self.key += f"_td_{total_discs}"
			if self.release_date is not None:
				self.key += f"_r_{release_date}"

	def add_song(self, song: ParsedSong):
		self.songs.append(song)

	def get_artist_directory(self):
		if self.album_artist == "Various Artists":
			return self.album_artist

		dirname = self.album_artist
		if self.album_artists is not None and len(album_artists) > 0:
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

			

parser = argparse.ArgumentParser(
	prog="song organizer",
	description="organizer of songs",
	epilog="hi",
)

parser.add_argument("source")
parser.add_argument("destination")
parser.add_argument("-d", "--delete", action="store_true", help="delete source files")
parser.add_argument("--dry-run", action="store_true", help="do nothing")

args = parser.parse_args()

dry_run = args.dry_run


src_dir = Path(args.source).resolve()
if not src_dir.exists():
	print(f"{src_dir.parent} doesn't exist")
	exit(-1)

dst_dir = Path(args.destination).resolve()
if not dst_dir.exists():
	if not dst_dir.parent.exists():
		print(f"{dst_dir} doesn't exist")
		exit(-1)
	if not dry_run:
		dst_dir.mkdir()

if src_dir.is_relative_to(dst_dir):
	tmp_src_dir = Path(f"{src_dir}.found").resolve()
	if tmp_src_dir.exists():
		print(f"couldnt create temp dir")
		exit(-1)
	if not dry_run:
		src_dir = src_dir.rename(tmp_src_dir)


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
		print(f"skipping {file} cause what even is that")
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
		total_discs=total_discs
	)

	album_key = parsed_album.key

	if album_key in albums:
		parsed_album = albums[album_key]
	else:
		albums[album_key] = parsed_album

	
	parsed_song = ParsedSong(
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
	

album_set = {}
for album in albums.values():
	if album.album_name in album_set:
		other_album = album_set[album.album_name]
		other_album.deduplicated_name = f"{other_album.album_name} {other_album.release_date}"
		album.deduplicated_name = f"{album.album_name} {album.release_date}"

		if other_album.deduplicated_name == album.deduplicated_name:
			print(f"unresolved duplicate: {album.album_artist - album.album_name}")
	else:
		album_set[album.album_name] = album

album_set = None


songs_skipped = 0
for album in albums.values():

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
		
			if args.delete:
				shutil.move(song.src_path, new_path)
				#song.src_path.move(new_path)
			else:
				shutil.copy2(song.src_path, new_path)
				#song.src_path.copy(new_path, preserve_metadata=True)

		print(f"{song.src_path} -> {new_path}") 

if songs_skipped != 0:
	print(f"{songs_skipped} were skipped, check the log for more detail")

for root, dirs, files in src_dir.walk(top_down=False):
	if not root.exists():
		continue

	if len(list(root.iterdir())) == 0 and not dry_run:
		root.rmdir()

if args.delete and not dry_run and src_dir.exists():
	print(f"files remain in {src_dir}")
