#!/usr/bin/env node

const fetch = (...args) =>
  import('node-fetch').then(({default: fetch}) => fetch(...args));

const API_KEY = process.env.PIXABAY_KEY;
if (!API_KEY) {
  console.error("環境変数 PIXABAY_KEY が設定されていません。");
  process.exit(1);
}

const query = process.argv[2];
if (!query) {
  console.error("Usage: pixabay_search <keyword>");
  process.exit(1);
}

const url = `https://pixabay.com/api/?key=${API_KEY}&q=${encodeURIComponent(query)}&image_type=photo&per_page=50`;

const main = async () => {
  const res = await fetch(url);
  const json = await res.json();

  json.hits.forEach(hit => {
    console.log(hit.largeImageURL);
  });
};

main();
