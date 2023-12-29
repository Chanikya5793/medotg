'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

<<<<<<< HEAD
const RESOURCES = {"404.html": "a4e2271d19eb1f6f93a15e1b7a4e74dd",
"assets/AssetManifest.bin": "a2a66ba95d00a9edf390d8d0373488d5",
"assets/AssetManifest.bin.json": "263b5e9d624a348de77e6f42c0c7dfec",
"assets/AssetManifest.json": "f398f9c42ce28bbfee8913ff5a687b8e",
"assets/assets/Images/1loading.gif": "166245ff058f9661470980178ef2cd40",
"assets/assets/Images/2loading.gif": "f8029882264044c4e5cb3ecca7ff9e3f",
"assets/assets/Images/loading.gif": "24048dcc69f31edd0b223ab2c2d7f4aa",
"assets/assets/Images/plants.png": "c613dd1dca9cae35a0eed04910f25f55",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "545c51afc4fa0067c1c5ba681542575b",
"assets/NOTICES": "d948c1a06d0ae3148b116185844d2079",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"canvaskit/canvaskit.js": "eb8797020acdbdf96a12fb0405582c1b",
"canvaskit/canvaskit.wasm": "73584c1a3367e3eaf757647a8f5c5989",
"canvaskit/chromium/canvaskit.js": "0ae8bbcc58155679458a0f7a00f66873",
"canvaskit/chromium/canvaskit.wasm": "143af6ff368f9cd21c863bfa4274c406",
"canvaskit/skwasm.js": "87063acf45c5e1ab9565dcf06b0c18b8",
"canvaskit/skwasm.wasm": "2fc47c0a0c3c7af8542b601634fe9674",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"firebase-debug.log": "e8efb43a3ba160bc30e2325e8f1ddaa4",
"flutter.js": "59a12ab9d00ae8f8096fffc417b6e84f",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "b7fb0bd19dc046e311a30f0f90ceb8b8",
"/": "b7fb0bd19dc046e311a30f0f90ceb8b8",
"main.dart.js": "19d453c5e988bcf2bf46ab3603980aba",
"manifest.json": "e0899a481a2af5b05aa63914048aca2f",
"splash/img/dark-1x.png": "3cda8875428c1b8177e90cfc1e42df42",
"splash/img/dark-2x.png": "225caec00b754919fcba7767012f59f6",
"splash/img/dark-3x.png": "db1157b84b19e093f16077437789faff",
"splash/img/dark-4x.png": "9a2b0ff3a7eb3394101d4eaea3fec61c",
"splash/img/light-1x.png": "3cda8875428c1b8177e90cfc1e42df42",
"splash/img/light-2x.png": "225caec00b754919fcba7767012f59f6",
"splash/img/light-3x.png": "db1157b84b19e093f16077437789faff",
"splash/img/light-4x.png": "9a2b0ff3a7eb3394101d4eaea3fec61c",
"splash/splash.js": "d6c41ac4d1fdd6c1bbe210f325a84ad4",
"splash/style.css": "a1be22a9b80f92af9ea169ce23757e2a",
"version.json": "5e07a036fe9a500252cbebb4e80bedfc"};
=======
const RESOURCES = {"version.json": "5e07a036fe9a500252cbebb4e80bedfc",
"splash/img/light-2x.png": "225caec00b754919fcba7767012f59f6",
"splash/img/dark-4x.png": "9a2b0ff3a7eb3394101d4eaea3fec61c",
"splash/img/light-3x.png": "db1157b84b19e093f16077437789faff",
"splash/img/dark-3x.png": "db1157b84b19e093f16077437789faff",
"splash/img/light-4x.png": "9a2b0ff3a7eb3394101d4eaea3fec61c",
"splash/img/dark-2x.png": "225caec00b754919fcba7767012f59f6",
"splash/img/dark-1x.png": "3cda8875428c1b8177e90cfc1e42df42",
"splash/img/light-1x.png": "3cda8875428c1b8177e90cfc1e42df42",
"splash/splash.js": "123c400b58bea74c1305ca3ac966748d",
"splash/style.css": "3c5b591b97a34727f13387f4e2637359",
"index.html": "f86b49e7b49d1945a88631db3af07d9e",
"/": "f86b49e7b49d1945a88631db3af07d9e",
"main.dart.js": "1167ad05adbabaed59eeb4137e25719c",
"404.html": "0a27a4163254fc8fce870c8cc3a3f94f",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "0130e8d69dad29a27c95d67efe41acb2",
"assets/AssetManifest.json": "eafd140b1fe296bf4a7036cc48255440",
"assets/NOTICES": "0373e25c9cbcdb0a9ba54785de32a735",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "0ed82943c3325542bc4cd8996ae26f0e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/shaders/ink_sparkle.frag": "4096b5150bac93c41cbc9b45276bd90f",
"assets/AssetManifest.bin": "a2138cc0c3ad65be4b2d24955e1be7ae",
"assets/fonts/MaterialIcons-Regular.otf": "545c51afc4fa0067c1c5ba681542575b",
"assets/assets/Images/2loading.gif": "f8029882264044c4e5cb3ecca7ff9e3f",
"assets/assets/Images/loading.gif": "24048dcc69f31edd0b223ab2c2d7f4aa",
"assets/assets/Images/plants.png": "c613dd1dca9cae35a0eed04910f25f55",
"assets/assets/Images/1loading.gif": "166245ff058f9661470980178ef2cd40",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.js.symbols": "c37c57bf1a5a958e3144da7df44254b0",
"canvaskit/canvaskit.js.symbols": "77cdc19fcc63a442fb89bc32e8a6c886",
"canvaskit/skwasm.wasm": "883abde2920007bba715d8ff470ccf8c",
"canvaskit/chromium/canvaskit.js.symbols": "0b594584ac3722580082cd02b6da9033",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.wasm": "d44c5e0a275d8cb84acff28ef31fa06a",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/canvaskit.wasm": "2db534eaad9e980f5028f0bcb8c54756",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03"};
>>>>>>> fd5b0ab (Update loading.gif and serviceWorkerVersion)
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
