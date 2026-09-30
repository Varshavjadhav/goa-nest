# GoaNest Admin

React admin console for managing the properties and discovery data used by the Flutter app.

## Local setup

1. Start MongoDB and the API in `Goanest-Backend` with `npm run dev`.
2. Create a local administrator in that backend directory:

   ```bash
   ADMIN_EMAIL=admin@goanest.com ADMIN_PASSWORD='Admin@123' npm run seed:admin
   ```

3. From `Goanest-Admin`, install packages and start the console:

   ```bash
   npm install
   npm run dev
   ```

   Open the local URL printed by Vite (usually `http://localhost:5173`). The default API is `http://localhost:5001/api/v1`.

## API configuration

Set `VITE_API_BASE_URL` in a local `.env` file or the deployment environment. Use the API origin plus versioned prefix, for example `https://goa-nest.vercel.app/api/v1` for the live API. Admin users are created by the backend seed command; the panel never connects directly to MongoDB.

Admin routes require a signed-in user with the `admin` role. Listing and category changes are read by the mobile app from the same database. Do not use a local development admin password in production.
