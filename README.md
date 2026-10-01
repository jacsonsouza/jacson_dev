# Jacson Dev Portfolio

[![CI](https://github.com/jacsonsouza/jacson_dev/actions/workflows/ci.yml/badge.svg)](https://github.com/jacsonsouza/jacson_dev/actions/workflows/ci.yml)

The source code for [jacson.dev.br](https://jacson.dev.br), a personal portfolio built with Ruby on Rails. Visitors can explore projects and skills, learn about my work, contact me, and ask questions through an AI chat. The application also includes a secure admin area for maintaining portfolio content.

## Why this project is useful

The portfolio is both a public-facing site and a production Rails application. It demonstrates end-to-end web development, from data modeling and responsive interfaces to automated checks and cloud deployment.

- Browse projects, related skills, and project details.
- Manage projects and skills through authenticated CRUD screens.
- Contact the maintainer with a form and review messages in the admin area.
- Ask the AI chat about the portfolio; responses stream as they are generated.
- View visit and project-skill analytics in the admin dashboard.
- Use English and Brazilian Portuguese interfaces.

## Technology

- Ruby on Rails 8.1, Ruby, and PostgreSQL
- Hotwire (Turbo and Stimulus), Tailwind CSS, and ViewComponent
- Devise authentication, Action Text, and Active Storage
- Minitest, Capybara, and Selenium for automated tests
- Docker Compose for local development; Docker and Kamal for deployment
- GitHub Actions for CI and production deployment
- Google Cloud Always Free VM for application hosting; Cloudflare R2 for production file storage

## Get started

### Prerequisites

- Git
- Docker Engine with the Docker Compose plugin

The development container provides Ruby and the required system libraries, so a host Ruby installation is not required.

### Setup

Clone the repository and start the database container:

```sh
git clone https://github.com/jacsonsouza/jacson_dev.git
cd jacson_dev
./run up -d db
```

Install the Ruby dependencies in the development container:

```sh
./run dcr web bundle install
```

Create local development credentials:

```sh
./run edit:credentials development
```

Add the local PostgreSQL connection settings to the credentials editor:

```yaml
database:
  host: db
  username: postgres
  password: postgres
```

Save the credentials and keep the generated key private. Rails credentials keys are ignored by Git and must not be committed. Configure an AI provider in development credentials if you want to use the AI chat; the rest of the portfolio can run without an external AI API key.

Create and migrate the development database, then start the web server:

```sh
./run dcr web bin/rails db:create db:migrate
./run up -d web
```

Open [http://localhost:3000](http://localhost:3000). Register the first local user to access the admin area. The application is designed for a single portfolio owner.

To stop the development services:

```sh
./run down
```

### Common commands

The `./run` script wraps Docker Compose commands. For example:

```sh
./run rails routes
./run rails db:migrate
./run shell
```

Start the test and browser services before running tests:

```sh
./run up -d db tests chrome-server
./run test test/models/project_test.rb
./run test:browser test/system/projects_test.rb
```

Run the project linters and security scan with:

```sh
./run rubocop
./run brakeman
```

CI also runs the full test suite, Brakeman, the Importmap JavaScript dependency audit, and RuboCop on pull requests and pushes to `main`.

## Help and documentation

- Visit the live [portfolio](https://jacson.dev.br).
- Report a bug or request a change through [GitHub Issues](https://github.com/jacsonsouza/jacson_dev/issues).
- Contact Jacson at [jacson.souza.dev@gmail.com](mailto:jacson.souza.dev@gmail.com).
- See [`AGENTS.md`](AGENTS.md) for repository conventions and project-specific development commands.
- See the [Rails Guides](https://guides.rubyonrails.org/) for Rails framework documentation.

## Maintainer and contributions

Maintained by [Jacson Souza](https://github.com/jacsonsouza). Contributions are welcome: open an issue to discuss a significant change, then submit a pull request with a clear description and relevant tests. Keep user-facing strings available in both English and Brazilian Portuguese, and follow the conventions in [`AGENTS.md`](AGENTS.md).

## License

This repository does not currently include a `LICENSE` file. Contact the maintainer before redistributing or reusing the code.
