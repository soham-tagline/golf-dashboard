# Rails Application Setup Guide

## Setup Instructions

### 1. Clone the Repository

Clone the repository to your local machine:

```bash
git clone git@github.com:soham-tagline/golf-dashboard.git
cd golf-dashboard
```

### 2. Install Dependencies

Install all required Ruby gems and JavaScript packages:

```bash
bundle install
```

Then, install the JavaScript dependencies:

```bash
yarn install
```

### 3. Setup the Database

Make sure your database is configured properly. If you're using PostgreSQL, you can create the database by running:

```bash
rails db:create
```

After that, run the migrations to set up your database schema:

```bash
rails db:migrate
```

### 4. Seed the Database

To populate your database with the initial data, run:

```bash
rails db:seed
```

This will execute the `db/seeds.rb` script, which typically includes creating default records (like users, categories, or sample data). You can modify the seed file to fit your app's requirements.

### 5. Start the Rails Server

Now, you can start the Rails development server:

```bash
rails server
```

Once the server starts, open your browser and visit:

```
http://localhost:3000
```

You should see your app running locally!

---
