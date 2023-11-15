require "open-uri"
require "nokogiri" # xml html

USER_AGENT = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36'


def fetch_movie_urls
  url = 'https://www.imdb.com/chart/top/'
  html = URI.open(url, "Accept-Language" => "en-US", "User-Agent" => USER_AGENT)
  doc = Nokogiri::HTML.parse(html)
  doc.search('.ipc-title-link-wrapper').take(5).map do |element|
    regexp = /\/title(\/\w{9}\/)/
    unique_url = element.attribute('href').value.match(regexp)[1]
    "https://www.imdb.com/title#{unique_url}"
  end
end

def scrape_movie(url)
  html = URI.open(url, "Accept-Language" => "en-US", "User-Agent" => USER_AGENT)
  doc = Nokogiri::HTML.parse(html)
  title = doc.search('.sc-7f1a92f5-1.benbRT').text.strip
  storyline = doc.search('.sc-466bb6c-2.chnFO').text.strip
  year = doc.search('.ipc-link.ipc-link--baseAlt.ipc-link--inherit-color')[5].text.strip.to_i
  director = doc.search('.ipc-metadata-list__item:contains("Director") a').first.text.strip
  cast = doc.search('.ipc-metadata-list__item:contains("Stars") a.ipc-metadata-list-item__list-content-item').map do |element|
    element.text.strip
  end.uniq
  {
    title: title,
    storyline: storyline,
    year: year,
    director: director,
    cast: cast
  }
end

p scrape_movie('https://www.imdb.com/title/tt0137523/')

