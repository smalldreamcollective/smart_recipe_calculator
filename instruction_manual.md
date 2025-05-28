# Smart Recipe Calculator - Development Environment Setup Guide

This guide will walk you through setting up the development environment for the Smart Recipe Calculator application. The application is built using Phoenix/Elixir for the backend, with LiveView for real-time user interfaces, and PostgreSQL for data storage.

## Prerequisites

Before you begin, ensure you have the following installed:
- Elixir (v1.18 or later)
- Erlang/OTP (v26 or later)
- PostgreSQL (v15 or later)
- Node.js (v18 or later) - for asset compilation
- Git

## Creating the Application

1. Create a new Phoenix application with LiveView support:
```bash
mix phx.new smart_recipe_calculator --live
```
This command creates a new Phoenix application with LiveView support. The `--live` flag adds LiveView dependencies and configuration.

2. When prompted, answer 'Y' to fetch and install dependencies:
```bash
Fetch and install dependencies? [Yn] Y
```

3. Navigate to the project directory:
```bash
cd smart_recipe_calculator
```

4. Update the database configuration in `config/dev.exs` to match your PostgreSQL setup:
```elixir
config :smart_recipe_calculator, SmartRecipeCalculator.Repo,
  username: "your_username",
  password: "your_password",
  hostname: "localhost",
  database: "smart_recipe_calculator_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

## Initial Setup

1. Install dependencies:
```bash
mix deps.get
```

2. Create and setup the database:
```bash
mix ecto.create
mix ecto.migrate
```

3. Install Node.js dependencies:
```bash
npm install
```

4. Start the Phoenix server:
```bash
mix phx.server
```

The application should now be running at `http://localhost:4000`

## Database Setup

The application uses PostgreSQL with the following schemas:

1. Users
2. Recipes
3. Ingredients
4. RecipeIngredients

To create these schemas, run:
```bash
mix ecto.gen.migration create_users
mix ecto.gen.migration create_recipes
mix ecto.gen.migration create_ingredients
mix ecto.gen.migration create_recipe_ingredients
```

## LiveView Components

The application uses Phoenix LiveView for real-time user interfaces. Here are the key components to create:

### User Authentication

1. Create the registration LiveView:
```bash
mix phx.gen.live Auth User users email:string password_hash:string
```

Reference UI: [Add registration form mockup here]

2. Create the login LiveView:
```bash
mix phx.gen.live Auth Session sessions user_id:references:users
```

Reference UI: [Add login form mockup here]

### Recipe Management

1. Create the recipe list LiveView:
```bash
mix phx.gen.live Recipes Recipe recipes name:string description:text user_id:references:users
```

Reference UI: [Add recipe list mockup here]

2. Create the recipe detail LiveView:
```bash
mix phx.gen.live Recipes RecipeDetail recipe_details recipe_id:references:recipes
```

Reference UI: [Add recipe detail mockup here]

### Ingredient Management

1. Create the ingredient list LiveView:
```bash
mix phx.gen.live Ingredients Ingredient ingredients name:string unit:string calories:integer protein:decimal fat:decimal carbs:decimal
```

Reference UI: [Add ingredient list mockup here]

2. Create the ingredient detail LiveView:
```bash
mix phx.gen.live Ingredients IngredientDetail ingredient_details ingredient_id:references:ingredients
```

Reference UI: [Add ingredient detail mockup here]

## API Endpoints

The application exposes RESTful API endpoints for integration with other systems. These are automatically generated when creating the LiveView components, but you may want to customize them:

1. User endpoints:
   - POST /api/users/register
   - POST /api/users/login
   - GET /api/users/me

2. Recipe endpoints:
   - GET /api/recipes
   - POST /api/recipes
   - GET /api/recipes/:id
   - PUT /api/recipes/:id
   - DELETE /api/recipes/:id

3. Ingredient endpoints:
   - GET /api/ingredients
   - POST /api/ingredients
   - GET /api/ingredients/:id
   - PUT /api/ingredients/:id
   - DELETE /api/ingredients/:id

## Testing

Run the test suite:
```bash
mix test
```

For specific test files:
```bash
mix test test/smart_recipe_calculator_web/live/recipe_live_test.exs
```

## Development Workflow

1. Start the development server:
```bash
mix phx.server
```

2. In a separate terminal, run the test watcher:
```bash
mix test.watch
```

3. For database changes:
```bash
mix ecto.migrate
```

## Troubleshooting

### Common Issues

1. Port 4000 already in use:
```bash
lsof -i :4000 | grep LISTEN | awk '{print $2}' | xargs kill -9
```

2. Database connection issues:
```bash
mix ecto.reset
```

3. Dependencies issues:
```bash
mix deps.clean --all
mix deps.get
```

## Documentation

- [Phoenix Framework Documentation](https://hexdocs.pm/phoenix/overview.html)
- [Ecto Documentation](https://hexdocs.pm/ecto/Ecto.html)
- [LiveView Documentation](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html)

## Contributing

1. Create a new branch:
```bash
git checkout -b feature/your-feature-name
```

2. Make your changes and commit:
```bash
git add .
git commit -m "Description of changes"
```

3. Push to the repository:
```bash
git push origin feature/your-feature-name
```

4. Create a pull request on GitHub

## Deployment

For production deployment, set the following environment variables:
```bash
export MIX_ENV=prod
export SECRET_KEY_BASE=your-secret-key
export DATABASE_URL=your-database-url
```

Then build the release:
```bash
mix deps.get --only prod
MIX_ENV=prod mix compile
MIX_ENV=prod mix assets.deploy
MIX_ENV=prod mix release
```

## Security Considerations

1. Ensure all API endpoints are properly authenticated
2. Use HTTPS in production
3. Implement rate limiting
4. Sanitize all user inputs
5. Keep dependencies updated

## Performance Optimization

1. Use database indexes for frequently queried fields
2. Implement caching where appropriate
3. Optimize database queries
4. Use connection pooling
5. Monitor application performance

## Monitoring

1. Set up logging:
```bash
mix phx.gen.live Monitoring Log logs level:string message:text
```

2. Configure error tracking:
```bash
mix phx.gen.live Monitoring Error errors type:string message:text stack_trace:text
```

## Backup and Recovery

1. Database backups:
```bash
pg_dump -U your_user your_database > backup.sql
```

2. Restore from backup:
```bash
psql -U your_user your_database < backup.sql
```

## Additional Resources

- [Elixir Documentation](https://elixir-lang.org/docs.html)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Phoenix LiveView Documentation](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html)
- [Ecto Documentation](https://hexdocs.pm/ecto/Ecto.html) 