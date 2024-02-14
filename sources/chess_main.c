#include "raylib.h"

#if defined(PLATFORM_WEB)
#include <emscripten/emscripten.h>
#endif

//------------------------------------------------------------------------------
// Global Variables Definition
//------------------------------------------------------------------------------
int screenWidth = 800;
int screenHeight = 450;
Texture2D texture;
Sound fx_missile_launch;
//------------------------------------------------------------------------------
// Module Functions Declaration
//------------------------------------------------------------------------------
void UpdateDrawFrame(void); // Update and Draw one frame

#ifdef ENABLE_TEST
int run_all_test(); // test runner
#endif

//------------------------------------------------------------------------------
// Main Entry Point
//------------------------------------------------------------------------------
int main()
{
#ifdef ENABLE_TEST
    return run_all_test();
#endif

    // Initialization
    //--------------------------------------------------------------------------
#ifndef DEBUG
    SetTraceLogLevel(LOG_WARNING);
#endif

    InitWindow(screenWidth, screenHeight, "Chess");
    InitAudioDevice();

    /// Load Assets
    texture = LoadTexture(ASSETS_PATH "test.png");
    fx_missile_launch = LoadSound(ASSETS_PATH "missile_launch.wav");

#if defined(PLATFORM_WEB)
    emscripten_set_main_loop(UpdateDrawFrame, 0, 1);
#else
    SetTargetFPS(60); // Set our game to run at 60 frames-per-second
    SetExitKey(0);
    //--------------------------------------------------------------------------

    // Main game loop
    while (!WindowShouldClose()) // Detect window close button or ESC key
    {
        UpdateDrawFrame();
    }
#endif

    // De-Initialization
    //--------------------------------------------------------------------------
    UnloadSound(fx_missile_launch);
    CloseAudioDevice();
    CloseWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------

    return 0;
}

//------------------------------------------------------------------------------
// Module Functions Definition
//------------------------------------------------------------------------------
void UpdateDrawFrame(void)
{
    // Update
    //--------------------------------------------------------------------------
    if (IsKeyPressed(KEY_ENTER))
        PlaySound(fx_missile_launch); // Play missile

    // Draw
    //--------------------------------------------------------------------------
    BeginDrawing();
    ClearBackground(RAYWHITE);

    const int texture_x = screenWidth / 2 - texture.width / 2;
    const int texture_y = screenHeight / 2 - texture.height / 2;
    DrawTexture(texture, texture_x, texture_y, WHITE);

    const char *text = "PRESS ENTER!";
    const Vector2 text_size = MeasureTextEx(GetFontDefault(), text, 20, 1);
    DrawText(text, (int)(screenWidth / 2) - text_size.x / 2,
             texture_y + texture.height + text_size.y + 10, 20, BLACK);

    // Draw human
    DrawCircle(100, 100, 50, YELLOW);
    DrawCircle(100, 100, 45, GREEN);
    DrawCircle(90, 100, 5, BLACK);
    DrawCircle(110, 100, 5, BLACK);
    DrawRectangle(90, 115, 20, 10, RED);
    DrawRectangle(50, 150, 100, 100, SKYBLUE);
    EndDrawing();
    //--------------------------------------------------------------------------
}
