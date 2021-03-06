//
//  Container.c
//  BlackOut
//
//  Created by Tony BELTRAMELLI on 13/12/12.
//
//

#include <stdio.h>

typedef enum {
    mainContainer,
    environmentContainer,
    topContainer,
    effectContainer
} containerId_t;

typedef enum {
    backgroundLayer,
    elementLayer
} layerId_t;

typedef enum {
    isOnRange,
    isTouched
} interactionType_t;

typedef enum {
    hero
} charatersId_t;