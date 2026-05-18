import '../models/album.dart';
import '../models/track.dart';

const sampleAlbums = [
  Album(
    id: '2-cool-4-skool',
    title: '2 Cool 4 Skool',
    artist: 'BTS',
    coverUrl: 'assets/images/2cool4skool.jpg',
    genre: 'Hip-Hop',
    vinylPrice: 24.99,
    tracks: [
      Track(
        title: 'No More Dream',
        audioPath: 'assets/audio/no_more_dream.mp3',
      ),
      Track(
        title: 'We Are Bulletproof Pt.2',
        audioPath: 'assets/audio/run_bts.mp3',
      ),
      Track(
        title: 'Like',
        audioPath: 'assets/audio/fake_love.mp3',
      ),
    ],
  ),
  Album(
    id: 'dark-and-wild',
    title: 'Dark & Wild',
    artist: 'BTS',
    coverUrl: 'assets/images/dark_and_wild.jpg',
    genre: 'Hip-Hop / Pop',
    vinylPrice: 32.99,
    tracks: [
      Track(
        title: 'Danger',
        audioPath: 'assets/audio/run_bts.mp3',
      ),
      Track(
        title: 'War of Hormone',
        audioPath: 'assets/audio/no_more_dream.mp3',
      ),
      Track(
        title: 'Let Me Know',
        audioPath: 'assets/audio/yet_to_come.mp3',
      ),
    ],
  ),
  Album(
    id: 'wings',
    title: 'Wings',
    artist: 'BTS',
    coverUrl: 'assets/images/wings.jpg',
    genre: 'K-Pop',
    vinylPrice: 36.99,
    tracks: [
      Track(
        title: 'Blood Sweat & Tears',
        audioPath: 'assets/audio/fake_love.mp3',
      ),
      Track(
        title: 'Begin',
        audioPath: 'assets/audio/dynamite.mp3',
      ),
      Track(
        title: 'Lie',
        audioPath: 'assets/audio/yet_to_come.mp3',
      ),
      Track(
        title: 'Stigma',
        audioPath: 'assets/audio/run_bts.mp3',
      ),
    ],
  ),
  Album(
    id: 'love-yourself-tear',
    title: 'Love Yourself: Tear',
    artist: 'BTS',
    coverUrl: 'assets/images/love_yourself_tear.jpeg',
    genre: 'Pop / R&B',
    vinylPrice: 39.99,
    tracks: [
      Track(
        title: 'Fake Love',
        audioPath: 'assets/audio/fake_love.mp3',
      ),
      Track(
        title: 'The Truth Untold',
        audioPath: 'assets/audio/yet_to_come.mp3',
      ),
      Track(
        title: 'Airplane Pt.2',
        audioPath: 'assets/audio/dynamite.mp3',
      ),
    ],
  ),
  Album(
    id: 'map-of-the-soul-7',
    title: 'Map of the Soul: 7',
    artist: 'BTS',
    coverUrl: 'assets/images/map_of_the_soul_7.png',
    genre: 'Pop / Hip-Hop',
    vinylPrice: 44.99,
    tracks: [
      Track(
        title: 'ON',
        audioPath: 'assets/audio/run_bts.mp3',
      ),
      Track(
        title: 'Black Swan',
        audioPath: 'assets/audio/fake_love.mp3',
      ),
      Track(
        title: 'Filter',
        audioPath: 'assets/audio/dynamite.mp3',
      ),
      Track(
        title: 'My Time',
        audioPath: 'assets/audio/yet_to_come.mp3',
      ),
    ],
  ),
  Album(
    id: 'be',
    title: 'BE',
    artist: 'BTS',
    coverUrl: 'assets/images/be.png',
    genre: 'Pop',
    vinylPrice: 41.99,
    tracks: [
      Track(
        title: 'Life Goes On',
        audioPath: 'assets/audio/yet_to_come.mp3',
      ),
      Track(
        title: 'Dynamite',
        audioPath: 'assets/audio/dynamite.mp3',
      ),
      Track(
        title: 'Blue & Grey',
        audioPath: 'assets/audio/fake_love.mp3',
      ),
      Track(
        title: 'Telepathy',
        audioPath: 'assets/audio/run_bts.mp3',
      ),
    ],
  ),
  Album(
    id: 'proof',
    title: 'Proof',
    artist: 'BTS',
    coverUrl: 'assets/images/proof.jpg',
    genre: 'Anthology',
    vinylPrice: 49.99,
    tracks: [
      Track(
        title: 'Yet To Come',
        audioPath: 'assets/audio/yet_to_come.mp3',
      ),
      Track(
        title: 'Run BTS',
        audioPath: 'assets/audio/run_bts.mp3',
      ),
      Track(
        title: 'For Youth',
        audioPath: 'assets/audio/dynamite.mp3',
      ),
    ],
  ),
];