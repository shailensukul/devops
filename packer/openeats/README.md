# OpenEats Project

OpenEats is a recipe management site that allows users to create, share, and store their personal collection of recipes. This fork uses Django Rest Framework as a backend and React (with flux) as a front end.

The usage for the app is intended for a single user or a small group. For my personal use, I would be an admin user and a few (about 5-6) friends and family would be normal users. Admin users can add other users to the project (no open sign-ups), make changes to the available Cuisines and Courses, and add to the homepage banner. Normal users just have the ability to add recipes. Below are a few of the core features the app provides.

- Creating, viewing, sharing, and editing recipes.
- Update Serving information on the fly.
- Browsing and searching for recipes.
- Creating grocery lists.
- Automatically add recipes to your grocery lists.
- Quickly print recipe.
- Linking recipes and ingredient grouping.

### [Read the docs on getting started here!](docs/Running_the_App.md)

If you don't wish to use docker, see installation instructions here:
[Markdown](docs/Running_the_App_Without_Docker.md) OR [Media Wiki!](https://wiki.tothnet.hu/books/other/page/install-openeats-without-docker-and-run-on-apache2)


### [The Update guide can be found here!](docs/Updating_the_App.md)

# Contributing
Please read the [contribution guidelines](CONTRIBUTING.md) in order to make the contribution process easy and effective for everyone involved.

For a guide on how to setup an environment for development see [this guide](docs/Running_the_App_in_dev.md).


# First Time Setup
Run the docker containers and kill it when they are ready
```
docker compose -f docker-prod.yml -f docker-prod.version.yml -f docker-prod.override.yml up
```

To create a super user
```
docker-compose -f docker-prod.yml run --rm --entrypoint "python manage.py createsuperuser" api
```

To create test data
```
docker-compose -f docker-prod.yml run --rm --entrypoint 'sh' api
# Run these 1 at a time
./manage.py loaddata course_data.json
./manage.py loaddata cuisine_data.json
./manage.py loaddata news_data.json
./manage.py loaddata recipe_data.json
./manage.py loaddata ing_data.json
```

# Clean

```
docker compose down 

docker rm -f $(docker ps -a -q)

docker volume rm $(docker volume ls -q)


```

Add a host entry
```
127.0.0.1 recipes.local
```
The url is `http://recipes.local:8000/`