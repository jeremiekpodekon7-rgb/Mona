#ifndef NPC_INTELLIGENCE_H
#define NPC_INTELLIGENCE_H
#include "game_configuration.h"

struct NonPlayerCharacter {
    int characterIdentifier;
    int isActive;
    int globalIdentifier;
    char characterName[20];
    int positionX;
    int positionY;
    int cityIdentifier;
    int characterType;
    int spriteIdentifier;
    int facingDirection;
    int artificialIntelligenceType;
    int intelligenceValue;
    int scheduleHours[4];
    int schedulePositionX[4];
    int schedulePositionY[4];
};

extern struct NonPlayerCharacter globalNonPlayerCharacters[MAXIMUM_NPC_COUNT];
extern int globalNonPlayerCharacterCount;

void non_player_character_generate_for_city(struct CityData* cityData);
void non_player_character_update_all(void);
int non_player_character_find_at_position(int x, int y);
int non_player_character_interact(int characterIdentifier);
#endif