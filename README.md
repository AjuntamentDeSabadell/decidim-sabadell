# decidim-sabadell

---

Citizen Participation and Open Government Application

This is the opensource code repository for "decidim-sabadell", based on [Decidim](https://github.com/AjuntamentdeSabadell/decidim).

## Development environment setup

You can setup everything with Docker & Docker compose, run:

```
docker-compose build
docker-compose run --rm app bundle exec rake db:create db:schema:load db:seed
docker-compose up
```

## Licence

Code published under AFFERO GPL v3 (see [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt))
