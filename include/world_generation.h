#ifndef WORLD_GENERATION_H
#define WORLD_GENERATION_H
#include "game_configuration.h"

struct CityData {
    int globalIdentifier;
    int planetIdentifier;
    int localIdentifier;
    char cityName[32];
    int cityType;
    int tilesetIdentifier;
    int populationCount;
    int hasShop;
    int hasInn;
    int hasGuild;
    int hasAuctionHouse;
    int hasGate;
    int hasPort;
    int dangerLevel;
    int seedValue;
};

struct PlanetData {
    int planetIdentifier;
    char planetName[24];
    char planetLore[80];
    int backgroundColor;
    int levelRequirement;
};

extern struct PlanetData globalPlanets[PLANET_COUNT];
extern struct CityData globalCurrentCity;

void planets_initialize(void);
void city_generate(int planetIdentifier, int cityLocalIdentifier, struct CityData* outputCity);
void city_load(int planetIdentifier, int cityLocalIdentifier);
void world_travel_to_planet(int planetIdentifier, int travelMethod);
int world_is_solid(int positionX, int positionY);
#endif