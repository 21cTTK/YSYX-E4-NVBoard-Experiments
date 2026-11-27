#include <SDL_image.h>
#include <cstdio>

int main(int argc, char** argv) {
    if (argc != 2) {
        std::fprintf(stderr, "Usage: img2hex image.png > picture.hex\n");
        return 1;
    }
    SDL_Surface* image = IMG_Load(argv[1]);
    if (!image) {
        std::fprintf(stderr, "%s\n", IMG_GetError());
        return 1;
    }
    SDL_Surface* rgb = SDL_ConvertSurfaceFormat(image, SDL_PIXELFORMAT_RGB24, 0);
    SDL_FreeSurface(image);
    if (!rgb) {
        std::fprintf(stderr, "%s\n", SDL_GetError());
        return 1;
    }
    const auto* pixels = static_cast<const unsigned char*>(rgb->pixels);
    for (int x = 0; x < 640; ++x) {
        for (int y = 0; y < 480; ++y) {
            const auto* p = pixels + (y * rgb->h / 480) * rgb->pitch + (x * rgb->w / 640) * 3;
            std::printf("%x%x%x\n", p[0] >> 4, p[1] >> 4, p[2] >> 4);
        }
        for (int y = 480; y < 512; ++y) std::puts("fff");
    }
    SDL_FreeSurface(rgb);
    return std::ferror(stdout) != 0;
}
