using api.Services;

var builder = WebApplication.CreateBuilder(args);

// 1. ADD SERVICES TO THE CONTAINER

// Configure a named CORS policy allowing your local React application interface
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowReactApp",
        policy => policy.WithOrigins("http://localhost:3000")
                        .AllowAnyHeader()
                        .AllowAnyMethod());
});

// Register IDatabaseService → SQLDatabaseService
builder.Services.AddScoped<IDatabaseService, SQLDatabaseService>();

builder.Services.AddControllers();
builder.Services.AddOpenApi();

var app = builder.Build();

// 2. CONFIGURE THE HTTP REQUEST PIPELINE

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

// Enforce the CORS middleware BEFORE routing or authorization occurs
app.UseCors("AllowReactApp");

app.UseAuthorization();

app.MapControllers();

app.Run();
