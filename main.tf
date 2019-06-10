provider "heroku" {
  version = "~> 2.0"  
}

resource "heroku_app" "default" {
  name   = "binancescrapper"
  region = "us"
#  stack = "container"
}


resource "heroku_build" "default" {
  app        = "${heroku_app.default.id}"
  buildpacks = ["https://github.com/HashNuke/heroku-buildpack-elixir"]

  source = {
    url     = "https://github.com/imerkle/binance_scrapper/archive/master.tar.gz"
    version = "master"
  }
}

resource "heroku_addon" "database" {
  app  = "${heroku_app.default.name}"
  plan = "heroku-postgresql:hobby-basic"
}