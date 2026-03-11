# Pexels

A comprehensive Dart client for the [Pexels API](https://www.pexels.com/api/). Search and access high-quality, royalty-free photos, videos, and curated collections.

## Features

- **Photos** - Search, browse curated selections, get by ID, or fetch a random photo
- **Videos** - Search, browse popular videos, get by ID, with filtering by dimensions and duration
- **Collections** - List your collections, browse featured collections, and retrieve collection media
- **Typed models** - Fully typed response models with JSON serialization
- **Custom HTTP client** - Inject your own `http.Client` for interceptors, logging, or testing
- **Error handling** - Throws `PexelsException` with status codes and messages on API errors

## Getting Started

### 1. Get an API Key

Sign up at [Pexels](https://www.pexels.com/api/) to get a free API key.

### 2. Install

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  pexels:
    path: packages/pexels  # or your package path
```

### 3. Import

```dart
import 'package:pexels/pexels.dart';
```

## Usage

### Create a Client

```dart
final client = PexelsClient(apiKey: 'YOUR_API_KEY');
```

Don't forget to close the client when you're done:

```dart
client.close();
```

### Custom HTTP Client

You can provide your own `http.Client` for interceptors, logging, or testing:

```dart
import 'package:http_interceptor/http_interceptor.dart';

final httpClient = InterceptedClient.build(interceptors: [
  LoggingInterceptor(),
]);

final client = PexelsClient(apiKey: 'YOUR_API_KEY', client: httpClient);
```

> When you provide a custom client, `close()` will **not** close it — you're responsible for managing its lifecycle.

---

## Photos

### Search Photos

Search for photos by keyword with optional filters.

```dart
final result = await client.searchPhotos(
  query: 'nature',
  perPage: 10,
  page: 1,
  orientation: 'landscape',  // 'landscape', 'portrait', or 'square'
  size: 'large',             // 'large', 'medium', or 'small'
  color: 'green',            // hex code (without #) or color name
  locale: 'en-US',
);

print('Total results: ${result.totalResults}');
for (final photo in result.photos) {
  print('${photo.photographer} - ${photo.src.medium}');
}
```

### Curated Photos

Get a curated list of photos hand-picked by the Pexels team.

```dart
final result = await client.getCuratedPhotos(perPage: 15, page: 1);

for (final photo in result.photos) {
  print('${photo.photographer}: ${photo.url}');
}
```

### Get a Photo by ID

```dart
final photo = await client.getPhoto(id: 2014422);

print(photo.photographer);       // "Joey Doe"
print(photo.src.original);       // Full resolution URL
print(photo.src.large2x);        // 940px wide, DPR 2
print(photo.src.landscape);      // 1200x627 cropped
print(photo.src.portrait);       // 800x1200 cropped
print(photo.src.tiny);           // 280x200 cropped
print(photo.avgColor);           // "#A1B2C3"
print(photo.alt);                // Alt text description
```

### Random Photo

Get a random curated photo.

```dart
final photo = await client.getRandomPhoto();
print('Random photo by ${photo.photographer}');
```

### Photo Model

Each `Photo` object contains:

| Property | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `width` | `int` | Width in pixels |
| `height` | `int` | Height in pixels |
| `url` | `String` | Pexels page URL |
| `alt` | `String?` | Alt text |
| `avgColor` | `String?` | Average color (hex) |
| `photographer` | `String` | Photographer name |
| `photographerUrl` | `String` | Photographer profile URL |
| `photographerId` | `int` | Photographer ID |
| `liked` | `bool` | Whether liked by current user |
| `src` | `PhotoSource` | Image URLs in multiple sizes |

`PhotoSource` sizes: `original`, `large2x`, `large`, `medium`, `small`, `portrait`, `landscape`, `tiny`.

---

## Videos

### Search Videos

Search for videos with optional dimension and duration filters.

```dart
final result = await client.searchVideos(
  query: 'ocean waves',
  perPage: 5,
  orientation: 'landscape',
  size: 'medium',
  minWidth: 1920,
  maxWidth: 3840,
  minDuration: 10,   // seconds
  maxDuration: 60,   // seconds
);

for (final video in result.videos) {
  print('${video.user.name} - ${video.duration}s');
  for (final file in video.videoFiles) {
    print('  ${file.quality} ${file.width}x${file.height}: ${file.link}');
  }
}
```

### Popular Videos

Get trending/popular videos.

```dart
final result = await client.getPopularVideos(
  perPage: 10,
  minWidth: 1280,
  maxDuration: 30,
);

for (final video in result.videos) {
  print('${video.user.name}: ${video.url}');
}
```

### Get a Video by ID

```dart
final video = await client.getVideo(id: 857251);

print(video.user.name);      // Videographer name
print(video.duration);        // Duration in seconds
print(video.image);           // Thumbnail URL
print(video.videoFiles);      // List of available files
print(video.videoPictures);   // Preview pictures
```

### Video Model

Each `Video` object contains:

| Property | Type | Description |
|---|---|---|
| `id` | `int` | Unique identifier |
| `width` | `int` | Width in pixels |
| `height` | `int` | Height in pixels |
| `url` | `String` | Pexels page URL |
| `image` | `String` | Thumbnail image URL |
| `duration` | `int` | Duration in seconds |
| `user` | `VideoUser` | Videographer info (`id`, `name`, `url`) |
| `videoFiles` | `List<VideoFile>` | Available video files |
| `videoPictures` | `List<VideoPicture>` | Preview pictures |

Each `VideoFile` contains: `id`, `quality` (`"hd"`, `"sd"`, `"hls"`), `fileType`, `width`, `height`, `link`, `fps`.

---

## Collections

### List All Collections

Retrieve all collections belonging to the authenticated user.

```dart
final result = await client.getAllCollections(perPage: 10, page: 1);

for (final collection in result.collections) {
  print('${collection.title}: ${collection.mediaCount} items');
  print('  Photos: ${collection.photosCount}, Videos: ${collection.videosCount}');
  print('  Private: ${collection.isPrivate}');
}
```

### Featured Collections

Browse collections curated by the Pexels team.

```dart
final result = await client.getFeaturedCollections(perPage: 10);

for (final collection in result.collections) {
  print('${collection.title} - ${collection.description}');
}
```

### Get Collection Media

Retrieve photos and videos from a specific collection.

```dart
final result = await client.getCollectionMedia(
  id: 'abc123',
  perPage: 20,
  type: 'photos',  // optional: 'photos' or 'videos'
);

print('Total items: ${result.totalResults}');

for (final item in result.media) {
  switch (item) {
    case PhotoMediaItem(:final photo):
      print('Photo: ${photo.photographer} - ${photo.src.medium}');
    case VideoMediaItem(:final video):
      print('Video: ${video.user.name} - ${video.duration}s');
  }
}
```

### Collection Model

| Property | Type | Description |
|---|---|---|
| `id` | `String` | Unique identifier |
| `title` | `String` | Collection title |
| `description` | `String?` | Collection description |
| `isPrivate` | `bool` | Whether the collection is private |
| `mediaCount` | `int` | Total media items |
| `photosCount` | `int` | Number of photos |
| `videosCount` | `int` | Number of videos |

---

## Pagination

All list endpoints return paginated responses with these fields:

| Field | Type | Description |
|---|---|---|
| `page` | `int` | Current page number |
| `perPage` | `int` | Results per page |
| `nextPage` | `String?` | URL of the next page (`null` on last page) |
| `totalResults` | `int?` | Total number of results (where available) |

### Paginating Through Results

```dart
var page = 1;
PhotoList result;

do {
  result = await client.searchPhotos(query: 'dogs', page: page, perPage: 40);

  for (final photo in result.photos) {
    // Process each photo
  }

  page++;
} while (result.nextPage != null);
```

---

## Error Handling

All API errors throw a `PexelsException`:

```dart
try {
  final photo = await client.getPhoto(id: 999999999);
} on PexelsException catch (e) {
  print(e.statusCode);  // e.g., 404
  print(e.message);     // e.g., "Not Found"
  print(e);             // "PexelsException(404): Not Found"
}
```

Common error codes:

| Status Code | Meaning |
|---|---|
| 401 | Invalid or missing API key |
| 403 | Rate limit exceeded |
| 404 | Resource not found |
| 500 | Pexels server error |

---

## API Reference

### PexelsClient

| Method | Returns | Description |
|---|---|---|
| `searchPhotos(...)` | `Future<PhotoList>` | Search photos by keyword |
| `getCuratedPhotos(...)` | `Future<PhotoList>` | Get curated photos |
| `getPhoto(id:)` | `Future<Photo>` | Get a single photo by ID |
| `getRandomPhoto()` | `Future<Photo>` | Get a random curated photo |
| `searchVideos(...)` | `Future<VideoList>` | Search videos by keyword |
| `getPopularVideos(...)` | `Future<VideoList>` | Get popular/trending videos |
| `getVideo(id:)` | `Future<Video>` | Get a single video by ID |
| `getAllCollections(...)` | `Future<CollectionList>` | List your collections |
| `getCollectionMedia(...)` | `Future<CollectionMediaList>` | Get media from a collection |
| `getFeaturedCollections(...)` | `Future<CollectionList>` | List featured collections |
| `close()` | `void` | Close the HTTP client |
