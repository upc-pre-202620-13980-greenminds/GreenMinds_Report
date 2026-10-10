# Catálogo de servicios REST de EcoMind

Código: [2264474](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Backend/commit/22644744806f6c2ce7eaa936942990f54e471635), integrado en `main` [a6d1491](https://github.com/upc-pre-202620-13980-greenminds/EcoMind_Backend/commit/a6d1491f722c8ee88cbd84337aa1c995e14be44c).

Contrato: [OpenAPI 3.1](openapi.json). Base de la instancia documentada: `http://localhost:8093`.

Los cuerpos se transmiten como JSON. Los endpoints protegidos reciben `Authorization: Bearer <token>`. Los ejemplos de invocación muestran la estructura del contrato; las respuestas obtenidas en ejecución se conservan en [api-responses.json](api-responses.json).

## GET `/api/v1/user/{id}`

Get a user profile

Returns the name, role, streak, ecopoints, gem balance and equipped cosmetic of a user.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `id` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Profile found | [UserProfileResource](#schema-userprofileresource) |
| 404 | The user has no profile | [ErrorResource](#schema-errorresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/user/1' -H 'Authorization: Bearer <token>'
```

## PUT `/api/v1/user/{id}`

Update the progress of a profile

Replaces the streak, last streak date, ecopoints and gem balance. A user can only update their own profile.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `id` | path | Sí | `integer` | — |

Cuerpo de la solicitud: [UpdateUserProfileResource](#schema-updateuserprofileresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Profile updated | [UserProfileResource](#schema-userprofileresource) |
| 400 | Missing or negative values | [ErrorResource](#schema-errorresource) |
| 403 | The profile belongs to another user | [ErrorResource](#schema-errorresource) |
| 404 | The user has no profile | [ErrorResource](#schema-errorresource) |

Ejemplo de invocación:

```sh
curl -X PUT 'http://localhost:8093/api/v1/user/1' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"streak": 6, "lastStreakDate": "2026-10-08", "ecopoints": 350, "gemBalance": 15}'
```

## GET `/api/v1/quests/{questId}`

Get quest by ID

Retrieves a quest using its unique identifier.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `questId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Quest found | [QuestResponse](#schema-questresponse) |
| 404 | Quest not found | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/quests/1' -H 'Authorization: Bearer <token>'
```

## PUT `/api/v1/quests/{questId}`

Update a quest

Updates a draft directly, or archives a published quest and creates a new draft version

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `questId` | path | Sí | `integer` | — |

Cuerpo de la solicitud: [UpdateQuestRequest](#schema-updatequestrequest).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Quest updated successfully | [QuestResponse](#schema-questresponse) |
| 400 | Invalid input data | `object` |
| 404 | Quest not found | `object` |

Ejemplo de invocación:

```sh
curl -X PUT 'http://localhost:8093/api/v1/quests/1' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"minigameId": 1, "title": "ejemplo", "description": "ejemplo", "category": "WATER", "type": "COLLABORATIVE", "gemReward": 1, "ecopoints": 1, "age": 1, "time": 1, "theme": "CHECKBOX", "assignedDate": "2026-10-10", "image": "ejemplo"}'
```

## PUT `/api/v1/monetization/me/cosmetics/{id}/equipped`

Equip an owned cosmetic

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `id` | path | Sí | `string` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 204 | No Content | Sin cuerpo |

Ejemplo de invocación:

```sh
curl -X PUT 'http://localhost:8093/api/v1/monetization/me/cosmetics/00000000-0000-4000-8000-000000000001/equipped' -H 'Authorization: Bearer <token>'
```

## DELETE `/api/v1/monetization/me/cosmetics/{id}/equipped`

Unequip an owned cosmetic

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `id` | path | Sí | `string` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 204 | No Content | Sin cuerpo |

Ejemplo de invocación:

```sh
curl -X DELETE 'http://localhost:8093/api/v1/monetization/me/cosmetics/00000000-0000-4000-8000-000000000001/equipped' -H 'Authorization: Bearer <token>'
```

## PUT `/api/v1/friend/{id}`

Answer a friend request

Accepts or rejects a pending friend request. Only the user who received it can answer.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `id` | path | Sí | `integer` | — |

Cuerpo de la solicitud: [RespondFriendRequestResource](#schema-respondfriendrequestresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Friend request answered | [FriendResource](#schema-friendresource) |
| 400 | Missing fields | [ErrorResource](#schema-errorresource) |
| 403 | The requester did not receive the request | [ErrorResource](#schema-errorresource) |
| 404 | The friend request does not exist | [ErrorResource](#schema-errorresource) |
| 422 | The request was already answered | [ErrorResource](#schema-errorresource) |

Ejemplo de invocación:

```sh
curl -X PUT 'http://localhost:8093/api/v1/friend/1' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"accepted": true}'
```

## GET `/api/v1/family-plans/{familyPlanId}`

Get family plan by id

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `familyPlanId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/family-plans/1' -H 'Authorization: Bearer <token>'
```

## PUT `/api/v1/family-plans/{familyPlanId}`

Update a draft family plan

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `familyPlanId` | path | Sí | `integer` | — |

Cuerpo de la solicitud: [UpdateFamilyPlanResource](#schema-updatefamilyplanresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X PUT 'http://localhost:8093/api/v1/family-plans/1' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"items": [{"questId": 1}]}'
```

## DELETE `/api/v1/family-plans/{familyPlanId}`

Delete or cancel a family plan

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `familyPlanId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X DELETE 'http://localhost:8093/api/v1/family-plans/1' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/activities/{activityId}`

Get activity by Id

Retrieve an activity using it's uniques identifier,

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `activityId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Activity found | [ActivityResponse](#schema-activityresponse) |
| 404 | Activity not found | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/activities/1' -H 'Authorization: Bearer <token>'
```

## PUT `/api/v1/activities/{activityId}`

Update an activity

Completely updates an activity. If its position changes, the other
activities in the quest are reordered automatically. The activity
type cannot be changed; it must be deleted and recreated instead.


| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `activityId` | path | Sí | `integer` | — |

Cuerpo de la solicitud: [UpdateActivityRequest](#schema-updateactivityrequest).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Activity updated successfully | [ActivityResponse](#schema-activityresponse) |
| 400 | Invalid input data | `object` |
| 404 | Activity not found | `object` |
| 422 | Activity type cannot be changed | `object` |

Ejemplo de invocación:

```sh
curl -X PUT 'http://localhost:8093/api/v1/activities/1' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"description": "ejemplo", "order": 1, "type": "CHECKBOX", "activityConfiguration": {}, "image": "ejemplo"}'
```

## DELETE `/api/v1/activities/{activityId}`

Delete an activity

Deletes an activity and all ActivityUser progress records associated
with it in a single transaction. Remaining activities are reordered
to keep their positions consecutive.


| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `activityId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 204 | Activity and related user progress deleted successfully | `object` |
| 404 | Activity not found | `object` |

Ejemplo de invocación:

```sh
curl -X DELETE 'http://localhost:8093/api/v1/activities/1' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/quests`

Get published quests

Retrieves the public quest catalog.

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Quests retrieved succesfully. | array de [QuestResponse](#schema-questresponse) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/quests' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/quests`

Create a new quest

Creates a new quest with all neccesary information.

Cuerpo de la solicitud: [CreateQuestRequest](#schema-createquestrequest).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Quest created succesfully | [QuestResponse](#schema-questresponse) |
| 400 | Invalid input data | `object` |
| 409 | Conflict: quest already exists | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/quests' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"minigameId": null, "title": "Turn off unnecessary lights", "description": "Turn off lights that are not being used.", "category": "ENERGY", "type": "ACTIVITIES", "gemReward": 30, "ecopoints": 30, "age": 8, "time": 10, "theme": "CHECKBOX", "assignedDate": "2026-06-12", "image": "https://example.com/quest.png"}'
```

## POST `/api/v1/quest-users`

Assign a quest to a user

Creates a quest assignment with IN_PROGRESS status and zero progress.
It also creates an ActivityUser with zero progress for each activity
belonging to the assigned quest.


Cuerpo de la solicitud: [CreateQuestUserRequest](#schema-createquestuserrequest).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Quest and its activity assignments created successfully | [QuestUserResponse](#schema-questuserresponse) |
| 400 | Invalid input data | `object` |
| 404 | Quest not found | `object` |
| 409 | Quest already assigned to user | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/quest-users' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"questId": 1, "collaborativeSessionId": null}'
```

## POST `/api/v1/quest-users/{questUserId}/complete`

Complete a quest assignment

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `questUserId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Quest completed | [QuestUserResponse](#schema-questuserresponse) |
| 404 | Quest assignment not found | `object` |
| 422 | Quest is not ready to complete | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/quest-users/1/complete' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/monetization/streak-protectors`

List active streak protectors

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [StreakProtectorResource](#schema-streakprotectorresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/monetization/streak-protectors' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/monetization/streak-protectors`

Create a streak protector

Cuerpo de la solicitud: [CreateStreakProtectorResource](#schema-createstreakprotectorresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Created | [StreakProtectorResource](#schema-streakprotectorresource) |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/monetization/streak-protectors' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"name": "ejemplo", "description": "ejemplo", "priceInGems": 1}'
```

## GET `/api/v1/monetization/multipliers`

List active multipliers

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [MultiplierResource](#schema-multiplierresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/monetization/multipliers' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/monetization/multipliers`

Create a multiplier

Cuerpo de la solicitud: [CreateMultiplierResource](#schema-createmultiplierresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Created | [MultiplierResource](#schema-multiplierresource) |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/monetization/multipliers' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"name": "ejemplo", "description": "ejemplo", "factor": 1.0, "durationMinutes": 1, "priceInGems": 1}'
```

## POST `/api/v1/monetization/me/protectors/purchases`

Buy a streak protector with gems

Cuerpo de la solicitud: [BuyItemResource](#schema-buyitemresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Created | [OwnedProtectorResource](#schema-ownedprotectorresource) |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/monetization/me/protectors/purchases' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"itemId": "00000000-0000-4000-8000-000000000001", "requestId": "00000000-0000-4000-8000-000000000001"}'
```

## POST `/api/v1/monetization/me/multipliers/purchases`

Buy and activate an XP multiplier with gems

Cuerpo de la solicitud: [BuyItemResource](#schema-buyitemresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Created | [OwnedMultiplierResource](#schema-ownedmultiplierresource) |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/monetization/me/multipliers/purchases' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"itemId": "00000000-0000-4000-8000-000000000001", "requestId": "00000000-0000-4000-8000-000000000001"}'
```

## GET `/api/v1/monetization/me/gem-purchases`

Get my gem package purchases

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [GemPurchaseResource](#schema-gempurchaseresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/monetization/me/gem-purchases' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/monetization/me/gem-purchases`

Start a gem package checkout

Cuerpo de la solicitud: [CreateGemPurchaseResource](#schema-creategempurchaseresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Created | [GemPurchaseResource](#schema-gempurchaseresource) |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/monetization/me/gem-purchases' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"packageId": "00000000-0000-4000-8000-000000000001", "paymentMethod": "CARD", "requestId": "00000000-0000-4000-8000-000000000001"}'
```

## POST `/api/v1/monetization/me/gem-purchases/{purchaseId}/payment`

Pay a pending gem package checkout

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `purchaseId` | path | Sí | `string` | — |

Cuerpo de la solicitud: [PayGemPurchaseResource](#schema-paygempurchaseresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | [GemPurchaseResource](#schema-gempurchaseresource) |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/monetization/me/gem-purchases/00000000-0000-4000-8000-000000000001/payment' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"sourceToken": "ejemplo", "email": "estudiante@example.com"}'
```

## POST `/api/v1/monetization/me/cosmetics/purchases`

Buy a cosmetic with gems

Cuerpo de la solicitud: [BuyItemResource](#schema-buyitemresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Created | [OwnedCosmeticResource](#schema-ownedcosmeticresource) |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/monetization/me/cosmetics/purchases' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"itemId": "00000000-0000-4000-8000-000000000001", "requestId": "00000000-0000-4000-8000-000000000001"}'
```

## GET `/api/v1/monetization/gem-packages`

List active gem packages

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [GemPackageResource](#schema-gempackageresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/monetization/gem-packages' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/monetization/gem-packages`

Create a gem package

Cuerpo de la solicitud: [CreateGemPackageResource](#schema-creategempackageresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Created | [GemPackageResource](#schema-gempackageresource) |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/monetization/gem-packages' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"name": "ejemplo", "gemAmount": 1, "price": 1, "currency": "ejemplo"}'
```

## GET `/api/v1/monetization/cosmetics`

List active cosmetics

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [CosmeticResource](#schema-cosmeticresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/monetization/cosmetics' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/monetization/cosmetics`

Create a cosmetic

Cuerpo de la solicitud: [CreateCosmeticResource](#schema-createcosmeticresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Created | [CosmeticResource](#schema-cosmeticresource) |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/monetization/cosmetics' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"name": "ejemplo", "description": "ejemplo", "priceInGems": 1, "type": "ejemplo", "imageUrl": "ejemplo"}'
```

## GET `/api/v1/minigames`

Get all minigames

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [MinigameResource](#schema-minigameresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/minigames' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/minigames`

Create a minigame

Cuerpo de la solicitud: [CreateMinigameRequest](#schema-createminigamerequest).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/minigames' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"name": "Recolector Eco", "description": "Suma puntos recolectando energia hasta alcanzar la meta.", "url": "/quests/minigames/simple-score", "completionRules": {"minScore": 800}}'
```

## GET `/api/v1/minigame-attempts`

Get minigame attempts by user and minigame

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `minigameId` | query | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [MinigameAttemptResource](#schema-minigameattemptresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/minigame-attempts?minigameId=1' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/minigame-attempts`

Create a minigame attempt

Cuerpo de la solicitud: [CreateMinigameAttemptRequest](#schema-createminigameattemptrequest).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Minigame attempt created successfully | [MinigameAttemptResource](#schema-minigameattemptresource) |
| 404 | User, quest, or minigame not found | `object` |
| 409 | User already has a started attempt | `object` |
| 422 | Quest is not a valid minigame quest | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/minigame-attempts' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"questId": 10}'
```

## POST `/api/v1/minigame-attempts/{attemptId}/finish`

Finish a minigame attempt

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `attemptId` | path | Sí | `integer` | — |

Cuerpo de la solicitud: [FinishMinigameAttemptResource](#schema-finishminigameattemptresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Minigame attempt finished successfully | [MinigameAttemptResource](#schema-minigameattemptresource) |
| 404 | Attempt, quest, or minigame not found | `object` |
| 422 | Attempt cannot be finished | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/minigame-attempts/1/finish' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"score": 1, "metadata": {}}'
```

## POST `/api/v1/minigame-attempts/{attemptId}/cancel`

Cancel a minigame attempt

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `attemptId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/minigame-attempts/1/cancel' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/gamification/achievement-shares`

Request publication of my individual achievement

Use the same requestId when retrying. PENDING does not mean a post was created.

Cuerpo de la solicitud: [ShareAchievementResource](#schema-shareachievementresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/gamification/achievement-shares' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"requestId": "00000000-0000-4000-8000-000000000001", "awardId": "00000000-0000-4000-8000-000000000001", "communityId": 1}'
```

## GET `/api/v1/friend`

List friend requests

Returns every friend request with its state, or only the ones a user sent or received when user_id is sent.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `user_id` | query | No | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Friend requests found | array de [FriendResource](#schema-friendresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/friend' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/friend`

Send a friend request

Sends a friend request from the authenticated user to another user. A request cannot be sent to oneself or repeated while one is pending or accepted; after a rejection it can be sent again once 7 days have passed.

Cuerpo de la solicitud: [SendFriendRequestResource](#schema-sendfriendrequestresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Friend request sent | [FriendResource](#schema-friendresource) |
| 400 | Missing or invalid fields | [ErrorResource](#schema-errorresource) |
| 404 | The receiver does not exist | [ErrorResource](#schema-errorresource) |
| 409 | A request already exists between the users | [ErrorResource](#schema-errorresource) |
| 422 | The request is to oneself or was rejected less than 7 days ago | [ErrorResource](#schema-errorresource) |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/friend' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"receiverId": 8}'
```

## GET `/api/v1/family_user`

List family members

Returns the members of every family, or only the membership of one user when user_id is sent.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `user_id` | query | No | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Members found | array de [FamilyMemberResource](#schema-familymemberresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/family_user' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/family_user`

Add a member to a family

Adds a user to the family with the given role. Only a parent of that family can do it, and the user must not belong to another family.

Cuerpo de la solicitud: [AddFamilyMemberResource](#schema-addfamilymemberresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Member added | [FamilyResource](#schema-familyresource) |
| 400 | Missing or invalid fields | [ErrorResource](#schema-errorresource) |
| 403 | The requester is not a parent of the family | [ErrorResource](#schema-errorresource) |
| 404 | The family or the user does not exist | [ErrorResource](#schema-errorresource) |
| 409 | The user already belongs to a family | [ErrorResource](#schema-errorresource) |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/family_user' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"familyId": 1, "userId": 8, "familyRole": "CHILD"}'
```

## GET `/api/v1/family`

List families

Returns every family with its members.

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Families found | array de [FamilyResource](#schema-familyresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/family' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/family`

Create a family

Creates a family whose first member is the authenticated user, with the PARENT role. Only users registered as parents can create one, and a user can belong to one family at a time.

Cuerpo de la solicitud: [CreateFamilyResource](#schema-createfamilyresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Family created | [FamilyResource](#schema-familyresource) |
| 400 | Missing or invalid fields | [ErrorResource](#schema-errorresource) |
| 409 | The user already belongs to a family | [ErrorResource](#schema-errorresource) |
| 422 | The user is not registered as a parent | [ErrorResource](#schema-errorresource) |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/family' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"name": "Torres Family", "commitment": "We will separate our waste every day"}'
```

## GET `/api/v1/family-plans`

Get family plans by family

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `familyId` | query | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [FamilyPlanResource](#schema-familyplanresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/family-plans?familyId=1' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/family-plans`

Create a family plan

Cuerpo de la solicitud: [CreateFamilyPlanResource](#schema-createfamilyplanresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/family-plans' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"familyId": 1, "items": [{"questId": 1}]}'
```

## POST `/api/v1/family-plans/{familyPlanId}/complete`

Complete an active family plan

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `familyPlanId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/family-plans/1/complete' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/family-plans/{familyPlanId}/activate`

Activate a family plan

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `familyPlanId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/family-plans/1/activate' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/collaborative-quests`

Create a collaborative quest session

Creates a pending collaborative session for a collaborative quest.
The session starts with null startedAt and completedAt dates.


Cuerpo de la solicitud: [CreateCollabQuestSessionRequest](#schema-createcollabquestsessionrequest).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Collaborative quest session created successfully | [CollabQuestSessionResource](#schema-collabquestsessionresource) |
| 404 | Quest not found | `object` |
| 409 | Session already exists | `object` |
| 422 | Quest is not collaborative | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/collaborative-quests' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"questId": 18}'
```

## POST `/api/v1/collaborative-quests/{sessionId}/start`

Start a collaborative quest session

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `sessionId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Collaborative quest session started successfully | [CollabQuestSessionResource](#schema-collabquestsessionresource) |
| 404 | Session not found | `object` |
| 409 | Quest already assigned | `object` |
| 422 | Session cannot be started | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/collaborative-quests/1/start' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/collaborative-quest-members`

Invite a user to a collaborative quest session

Creates a pending participant member invitation.
The invited user must be an accepted friend or family member.


Cuerpo de la solicitud: [InviteCollabQuestMemberRequest](#schema-invitecollabquestmemberrequest).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Collaborative quest member invited successfully | [CollabQuestMemberResource](#schema-collabquestmemberresource) |
| 404 | Session or user not found | `object` |
| 409 | Invitation conflicts with existing membership | `object` |
| 422 | Invitation is not allowed | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/collaborative-quest-members' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"sessionId": 1, "invitedUserId": 3}'
```

## POST `/api/v1/authentication/verify-email`

Verify the email and create the account

Checks the code sent by email. The code is valid for 20 minutes, can be used once and allows up to 5 attempts. When it is correct the account is created.

Cuerpo de la solicitud: [VerifyEmailResource](#schema-verifyemailresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Account created | [AuthenticatedUserResource](#schema-authenticateduserresource) |
| 400 | Missing or invalid fields | [ErrorResource](#schema-errorresource) |
| 409 | The email was registered in the meantime | [ErrorResource](#schema-errorresource) |
| 422 | The code is wrong, expired or has too many attempts | [ErrorResource](#schema-errorresource) |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/authentication/verify-email' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"email": "camila.torres@example.com", "code": "482913"}'
```

## POST `/api/v1/authentication/sign-up`

Start a registration

Stores the registration as pending and sends a six-digit verification code to the email address. The account is created only after the email is verified. Submitting again for the same email replaces the previous code.

Cuerpo de la solicitud: [SubmitRegistrationResource](#schema-submitregistrationresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Registration pending verification | [PendingRegistrationResource](#schema-pendingregistrationresource) |
| 400 | Missing or invalid fields, or weak password | [ErrorResource](#schema-errorresource) |
| 409 | The email already has an account | [ErrorResource](#schema-errorresource) |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/authentication/sign-up' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"name": "Camila Torres", "email": "camila.torres@example.com", "password": "GreenPlanet2026", "socialRole": "STUDENT"}'
```

## POST `/api/v1/authentication/sign-in`

Sign in

Validates the credentials and returns a signed access token. The error is the same whether the email or the password is wrong.

Cuerpo de la solicitud: [SignInResource](#schema-signinresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Authenticated | [AuthenticationResource](#schema-authenticationresource) |
| 400 | Missing fields | [ErrorResource](#schema-errorresource) |
| 401 | Invalid credentials | [ErrorResource](#schema-errorresource) |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/authentication/sign-in' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"email": "camila.torres@example.com", "password": "GreenPlanet2026"}'
```

## POST `/api/v1/authentication/password-recovery/request`

Request a password recovery

Sends a recovery link to the email address when it belongs to an account. The response is the same for any email, so it does not reveal which ones are registered.

Cuerpo de la solicitud: [PasswordRecoveryResource](#schema-passwordrecoveryresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Request accepted | [MessageResource](#schema-messageresource) |
| 400 | Missing or malformed email | [ErrorResource](#schema-errorresource) |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/authentication/password-recovery/request' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"email": "camila.torres@example.com"}'
```

## POST `/api/v1/authentication/password-recovery/confirm`

Set a new password

Consumes the token of the recovery link, which is valid for 30 minutes and can be used once, and replaces the password of the account.

Cuerpo de la solicitud: [ConfirmPasswordRecoveryResource](#schema-confirmpasswordrecoveryresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 204 | Password updated | Sin cuerpo |
| 400 | Missing fields or weak password | [ErrorResource](#schema-errorresource) |
| 422 | The token is wrong, expired or already used | [ErrorResource](#schema-errorresource) |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/authentication/password-recovery/confirm' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"token": "q8Zr1mF0sVJ3o2cXbT7yLk5nA9dEwHuG4iPpQeRtYsU", "newPassword": "NewGreenPlanet2026"}'
```

## POST `/api/v1/authentication/logout`

Log out

Confirms the end of the session. Access tokens are stateless: the client must discard its token, which is not revoked on the server.

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 204 | Session finished | Sin cuerpo |
| 401 | Missing, invalid or expired access token | [ErrorResource](#schema-errorresource) |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/authentication/logout' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/activity-users`

Assign an activity to a quest user

Creates an activity assignment with zero progress

Cuerpo de la solicitud: [CreateActivityUserRequest](#schema-createactivityuserrequest).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Activity assigned successfully | [ActivityUserResource](#schema-activityuserresource) |
| 400 | Invalid input data | `object` |
| 404 | Quest user or activity not found | `object` |
| 409 | Activity already assigned | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/activity-users' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"questUserId": 1, "activityId": 1, "collaborativeSessionId": null}'
```

## POST `/api/v1/activity-users/{activityUserId}/submit`

Submit progress for an activity

For CHECKBOX activities, send {"data":{"checked":true}}

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `activityUserId` | path | Sí | `integer` | — |

Cuerpo de la solicitud: [SubmitActivityUserResource](#schema-submitactivityuserresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Activity submitted | [ActivityUserResource](#schema-activityuserresource) |
| 400 | Invalid submission data | `object` |
| 404 | Activity assignment not found | `object` |
| 422 | Submission is not allowed | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/activity-users/1/submit' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"data": {"checked": true}}'
```

## POST `/api/v1/activities`

Create a new activity

Creates an activity for a quest

Cuerpo de la solicitud: [CreateActivityRequest](#schema-createactivityrequest).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 201 | Activity created | [ActivityResponse](#schema-activityresponse) |
| 400 | Invalid input data | `object` |
| 409 | Conflict: activity already exists | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/activities' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"questId": 1, "description": "Check the rooms", "order": 1, "type": "CHECKBOX", "activityConfiguration": null, "image": null}'
```

## GET `/api/v1/Community/Posts`

list

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `community_id` | query | No | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [PostResource](#schema-postresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/Community/Posts' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/Community/Posts`

create_4

Cuerpo de la solicitud: [CreatePostResource](#schema-createpostresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/Community/Posts' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"community_id": 1, "content": "We completed a neighborhood energy-saving activity!", "image_url": "https://example.com/activity.png"}'
```

## POST `/api/v1/Community/Post-Reactions`

create_5

Cuerpo de la solicitud: [CreatePostReactionResource](#schema-createpostreactionresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/Community/Post-Reactions' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"post_id": 1, "reaction_type": "like"}'
```

## GET `/api/v1/Community/Events`

list_1

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `community_id` | query | No | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [EventResource](#schema-eventresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/Community/Events' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/Community/Events`

create_6

Cuerpo de la solicitud: [CreateEvent](#schema-createevent).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/Community/Events' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"community_id": 1, "name": "Community garden cleanup", "description": "We will clean and prepare the neighborhood garden.", "date": "2026-11-09", "start_time": "12:00:00", "location": "315 Paloma Avenue, Lima", "latitude": -12.0464, "longitude": -77.0428, "capacity": 40, "image_url": "https://example.com/garden-cleanup.png"}'
```

## GET `/api/v1/Community/Events/{eventId}/Registrations`

list_2

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `eventId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [EventRegistrationResource](#schema-eventregistrationresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/Community/Events/1/Registrations' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/Community/Events/{eventId}/Registrations`

register

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `eventId` | path | Sí | `integer` | — |

Cuerpo de la solicitud: [CreateEventRegistrationResource](#schema-createeventregistrationresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/Community/Events/1/Registrations' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"registration_type": "INDIVIDUAL", "family_id": 1}'
```

## GET `/api/v1/Community/Community-goals`

list_3

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `community_id` | query | No | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [CommunityGoalResource](#schema-communitygoalresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/Community/Community-goals' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/Community/Community-goals`

create_7

Cuerpo de la solicitud: [CreateCommunityGoalResource](#schema-createcommunitygoalresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/Community/Community-goals' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"community_id": 1, "topic": "energy", "target": 500}'
```

## GET `/api/v1/Community/Communities/{communityId}/Memberships`

membershipsByCommunity

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `communityId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [CommunityMembershipResource](#schema-communitymembershipresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/Community/Communities/1/Memberships' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/Community/Communities/{communityId}/Memberships`

join

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `communityId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/Community/Communities/1/Memberships' -H 'Authorization: Bearer <token>'
```

## POST `/api/v1/Community/Communities/Topics`

createTopic

Cuerpo de la solicitud: [CreateTopicCommunityResource](#schema-createtopiccommunityresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/Community/Communities/Topics' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"name": "Water Guardians", "description": "A community dedicated to saving water.", "topic": "water", "member_limit": 100, "icon_url": "https://example.com/water-community.png"}'
```

## POST `/api/v1/Community/Communities/Local`

createLocal

Cuerpo de la solicitud: [CreateLocalCommunityResource](#schema-createlocalcommunityresource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X POST 'http://localhost:8093/api/v1/Community/Communities/Local' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"name": "Lima Green Community", "description": "Neighbors working together for a greener city.", "locality": "Lima", "icon_url": "https://example.com/community-icon.png"}'
```

## PATCH `/api/v1/quests/{questId}/publish`

Publish a draft quest

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `questId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X PATCH 'http://localhost:8093/api/v1/quests/1/publish' -H 'Authorization: Bearer <token>'
```

## PATCH `/api/v1/quests/{questId}/archive`

Archive a quest

Archives the quest without deleting its history.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `questId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 204 | Quest archived successfully | `object` |
| 404 | Quest not found | `object` |

Ejemplo de invocación:

```sh
curl -X PATCH 'http://localhost:8093/api/v1/quests/1/archive' -H 'Authorization: Bearer <token>'
```

## PATCH `/api/v1/quest-users/{questUserId}/cancel`

Cancel a user's quest assignment

Cancels the assignment while preserving its progress history.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `questUserId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Quest assignment cancelled successfully | `object` |
| 404 | Quest assignment not found | `object` |

Ejemplo de invocación:

```sh
curl -X PATCH 'http://localhost:8093/api/v1/quest-users/1/cancel' -H 'Authorization: Bearer <token>'
```

## PATCH `/api/v1/collaborative-quest-members/{memberId}/remove`

Remove an invited collaborative quest member

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `memberId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Collaborative quest member removed successfully | [CollabQuestMemberResource](#schema-collabquestmemberresource) |
| 404 | Member or session not found | `object` |
| 422 | Member cannot be removed | `object` |

Ejemplo de invocación:

```sh
curl -X PATCH 'http://localhost:8093/api/v1/collaborative-quest-members/1/remove' -H 'Authorization: Bearer <token>'
```

## PATCH `/api/v1/collaborative-quest-members/{memberId}/leave`

Leave a collaborative quest session

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `memberId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Collaborative quest member left successfully | [CollabQuestMemberResource](#schema-collabquestmemberresource) |
| 404 | Member or session not found | `object` |
| 422 | Member cannot leave | `object` |

Ejemplo de invocación:

```sh
curl -X PATCH 'http://localhost:8093/api/v1/collaborative-quest-members/1/leave' -H 'Authorization: Bearer <token>'
```

## PATCH `/api/v1/collaborative-quest-members/{memberId}/decline`

Decline a collaborative quest invitation

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `memberId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Collaborative quest invitation declined successfully | [CollabQuestMemberResource](#schema-collabquestmemberresource) |
| 404 | Member not found | `object` |
| 422 | Invitation cannot be declined | `object` |

Ejemplo de invocación:

```sh
curl -X PATCH 'http://localhost:8093/api/v1/collaborative-quest-members/1/decline' -H 'Authorization: Bearer <token>'
```

## PATCH `/api/v1/collaborative-quest-members/{memberId}/accept`

Accept a collaborative quest invitation

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `memberId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Collaborative quest invitation accepted successfully | [CollabQuestMemberResource](#schema-collabquestmemberresource) |
| 404 | Member not found | `object` |
| 409 | User already accepted this quest elsewhere | `object` |
| 422 | Invitation cannot be accepted | `object` |

Ejemplo de invocación:

```sh
curl -X PATCH 'http://localhost:8093/api/v1/collaborative-quest-members/1/accept' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/Community/Posts/{postId}/Reactions`

list_4

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `postId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [PostReactionResource](#schema-postreactionresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/Community/Posts/1/Reactions' -H 'Authorization: Bearer <token>'
```

## DELETE `/api/v1/Community/Posts/{postId}/Reactions`

delete

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `postId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X DELETE 'http://localhost:8093/api/v1/Community/Posts/1/Reactions' -H 'Authorization: Bearer <token>'
```

## PATCH `/api/v1/Community/Posts/{postId}/Reactions`

update

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `postId` | path | Sí | `integer` | — |

Cuerpo de la solicitud: [UpdatePostReactionTypeResource](#schema-updatepostreactiontyperesource).

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X PATCH 'http://localhost:8093/api/v1/Community/Posts/1/Reactions' -H 'Authorization: Bearer <token>' -H 'Content-Type: application/json' --data '{"reaction_type": "love"}'
```

## PATCH `/api/v1/Community/Events/{eventId}/Registrations/{registrationId}/cancel`

cancel

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `eventId` | path | Sí | `integer` | — |
| `registrationId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X PATCH 'http://localhost:8093/api/v1/Community/Events/1/Registrations/1/cancel' -H 'Authorization: Bearer <token>'
```

## PATCH `/api/v1/Community/Community-goals/{id}/progress`

increment

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `id` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X PATCH 'http://localhost:8093/api/v1/Community/Community-goals/1/progress' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/user_achievement`

TS-006: get my individual achievement awards

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `user_id` | query | No | `integer` | — |
| `page` | query | No | `integer` | — |
| `size` | query | No | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/user_achievement' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/user`

List user profiles

Returns every registered profile.

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Profiles found | array de [UserProfileResource](#schema-userprofileresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/user' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/ranking`

TS-007: get available ranking types

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de `string` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/ranking' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/quests/version-groups/{versionGroupId}/versions`

getQuestVersions

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `versionGroupId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [QuestResponse](#schema-questresponse) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/quests/version-groups/1/versions' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/quests/search`

Search quests

Searches quests using optional filters.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `title` | query | No | `string` | — |
| `category` | query | No | `string` | WATER, RECYCLE, ENERGY |
| `questType` | query | No | `string` | COLLABORATIVE, MINIGAME, ACTIVITIES, DAILY_QUEST, FAMILY |
| `age` | query | No | `integer` | — |
| `type` | query | No | `string` | CHECKBOX, MINIGAME, COLLABORATIVE |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Search completed successfully | array de [QuestResponse](#schema-questresponse) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/quests/search' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/quest-users/{questUserId}`

Get quest assignment by ID

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `questUserId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/quest-users/1' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/quest-users/{questUserId}/version-status`

Check if a quest assignment is up to date

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `questUserId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Version status | [QuestUserVersionStatusResponse](#schema-questuserversionstatusresponse) |
| 404 | Quest assignment not found | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/quest-users/1/version-status' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/quest-users/me/status/{status}`

Get the authenticated user's quest assignments by status

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `status` | path | Sí | `string` | READY_TO_COMPLETE, IN_PROGRESS, COMPLETED, EXPIRED, CANCELLED |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [QuestUserResponse](#schema-questuserresponse) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/quest-users/me/status/READY_TO_COMPLETE' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/quest-users/me/quest/{questId}`

Get the authenticated user's assignment for a quest

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `questId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/quest-users/me/quest/1' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/monetization/streak-protectors/{id}`

Get an active streak protector by ID

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `id` | path | Sí | `string` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | [StreakProtectorResource](#schema-streakprotectorresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/monetization/streak-protectors/00000000-0000-4000-8000-000000000001' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/monetization/store`

Browse the active EcoMind store catalog

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | [StoreCatalogResource](#schema-storecatalogresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/monetization/store' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/monetization/multipliers/{id}`

Get an active multiplier by ID

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `id` | path | Sí | `string` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | [MultiplierResource](#schema-multiplierresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/monetization/multipliers/00000000-0000-4000-8000-000000000001' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/monetization/me/wallet`

Get my gem balance

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | [GemWalletResource](#schema-gemwalletresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/monetization/me/wallet' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/monetization/me/wallet/movements`

Get my 100 most recent gem movements

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [GemMovementResource](#schema-gemmovementresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/monetization/me/wallet/movements' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/monetization/me/inventory`

Get my virtual inventory

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | [InventoryResource](#schema-inventoryresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/monetization/me/inventory' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/monetization/me/gem-purchases/{purchaseId}`

Get one of my gem package purchases by ID

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `purchaseId` | path | Sí | `string` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | [GemPurchaseResource](#schema-gempurchaseresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/monetization/me/gem-purchases/00000000-0000-4000-8000-000000000001' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/monetization/gem-packages/{id}`

Get an active gem package by ID

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `id` | path | Sí | `string` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | [GemPackageResource](#schema-gempackageresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/monetization/gem-packages/00000000-0000-4000-8000-000000000001' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/monetization/cosmetics/{id}`

Get an active cosmetic by ID

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `id` | path | Sí | `string` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | [CosmeticResource](#schema-cosmeticresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/monetization/cosmetics/00000000-0000-4000-8000-000000000001' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/minigames/{minigameId}`

Get a minigame by id

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `minigameId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/minigames/1' -H 'Authorization: Bearer <token>'
```

## DELETE `/api/v1/minigames/{minigameId}`

Delete a minigame

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `minigameId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X DELETE 'http://localhost:8093/api/v1/minigames/1' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/gamification/rewards`

Get authorized reward history for a beneficiary and period

Inclusive from, exclusive to. Pages start at zero; maximum size 100. USER defaults to the authenticated account.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `beneficiaryType` | query | No | `string` | USER, FAMILY |
| `beneficiaryId` | query | No | `integer` | — |
| `from` | query | Sí | `string` | — |
| `to` | query | Sí | `string` | — |
| `page` | query | No | `integer` | — |
| `size` | query | No | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/gamification/rewards?from=2026-10-10T10:00:00Z&to=2026-10-10T10:00:00Z' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/gamification/rankings/{type}/transactions`

Get ecopoint transactions for client-side period ranking

UTC from is inclusive and to is exclusive. Follow hasNext to aggregate all pages. Pages start at zero; maximum size is 100. Queries never grant rewards.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `type` | path | Sí | `string` | LOCAL, GLOBAL, FRIENDS, FAMILIES |
| `from` | query | Sí | `string` | — |
| `to` | query | Sí | `string` | — |
| `page` | query | No | `integer` | — |
| `size` | query | No | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | [PageResourceRankingTransactionResource](#schema-pageresourcerankingtransactionresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/gamification/rankings/LOCAL/transactions?from=2026-10-10T10:00:00Z&to=2026-10-10T10:00:00Z' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/gamification/rankings/{type}/participants`

Get ranking participants and accumulated ecopoints

Ordered by identity, not position. FRIENDS includes the JWT holder and accepted friends. Pages start at zero; maximum size is 100.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `type` | path | Sí | `string` | LOCAL, GLOBAL, FRIENDS, FAMILIES |
| `page` | query | No | `integer` | — |
| `size` | query | No | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | [PageResourceRankingEntryResource](#schema-pageresourcerankingentryresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/gamification/rankings/LOCAL/participants' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/gamification/rankings/types`

Get available ranking types

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de `string` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/gamification/rankings/types' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/gamification/me/rewards`

Get my 100 most recent reward transactions

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [RewardTransactionResource](#schema-rewardtransactionresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/gamification/me/rewards' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/gamification/me/progress`

Get my XP (ecopoints) and daily streak

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | [UserProgressResource](#schema-userprogressresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/gamification/me/progress' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/gamification/me/achievements`

Get my awarded achievements

Pages start at zero; maximum size is 100.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `page` | query | No | `integer` | — |
| `size` | query | No | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [AchievementAwardResource](#schema-achievementawardresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/gamification/me/achievements' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/gamification/families/{familyId}/score`

Get a family's ecopoints

Available to current family members only.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `familyId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/gamification/families/1/score' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/gamification/families/{familyId}/rewards`

Get a family's 100 most recent rewards

Available to current family members only.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `familyId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/gamification/families/1/rewards' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/gamification/families/{familyId}/achievements`

Get a family's awarded achievements

Requires current family membership. Pages start at zero; maximum size is 100.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `familyId` | path | Sí | `integer` | — |
| `page` | query | No | `integer` | — |
| `size` | query | No | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/gamification/families/1/achievements' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/gamification/communities/{communityId}/achievements`

Get collective achievements awarded to my community

Requires community membership. Shared individual achievements remain in Community's feed.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `communityId` | path | Sí | `integer` | — |
| `page` | query | No | `integer` | — |
| `size` | query | No | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/gamification/communities/1/achievements' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/gamification/achievements`

Browse the achievement catalog

Optional scope filter. Pages start at zero; maximum size is 100. Includes inactive definitions.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `scope` | query | No | `string` | INDIVIDUAL, FAMILY, COMMUNITY |
| `page` | query | No | `integer` | — |
| `size` | query | No | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [AchievementResource](#schema-achievementresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/gamification/achievements' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/gamification/achievements/{achievementId}`

Get an achievement definition

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `achievementId` | path | Sí | `string` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/gamification/achievements/00000000-0000-4000-8000-000000000001' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/gamification/achievement-shares/{requestId}`

Get the status of my publication request

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `requestId` | path | Sí | `string` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/gamification/achievement-shares/00000000-0000-4000-8000-000000000001' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/family-plans/active`

Get active family plan

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `familyId` | query | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/family-plans/active?familyId=1' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/ecopoint_transaction`

TS-007: get authorized transactions for weekly ranking

Android computes positions. Inclusive from, exclusive to.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `type` | query | No | `string` | GLOBAL, FRIENDS, FAMILIES, LOCAL |
| `from` | query | Sí | `string` | — |
| `to` | query | Sí | `string` | — |
| `page` | query | No | `integer` | — |
| `size` | query | No | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | [PageResourceRankingTransactionResource](#schema-pageresourcerankingtransactionresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/ecopoint_transaction?from=2026-10-10T10:00:00Z&to=2026-10-10T10:00:00Z' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/community_achievement`

TS-006: get collective community awards

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `community_id` | query | Sí | `integer` | — |
| `page` | query | No | `integer` | — |
| `size` | query | No | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/community_achievement?community_id=1' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/collaborative-quests/state`

Get collaborative quest state

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `questId` | query | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Collaborative quest state retrieved successfully | [CollabQuestSessionStateResource](#schema-collabquestsessionstateresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/collaborative-quests/state?questId=1' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/collaborative-quest-members/{memberId}`

Get a collaborative quest member by ID

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `memberId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/collaborative-quest-members/1' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/collaborative-quest-members/sessions/{sessionId}`

Get all members of a collaborative quest session

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `sessionId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [CollabQuestMemberResource](#schema-collabquestmemberresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/collaborative-quest-members/sessions/1' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/collaborative-quest-members/me`

Get the authenticated user's collaborative memberships or invitations

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `status` | query | No | `string` | ACCEPTED, REJECTED, PENDING, LEFT |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [CollabQuestMemberResource](#schema-collabquestmemberresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/collaborative-quest-members/me' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/authentication/me`

Get the authenticated account

Returns the identity of the account that owns the access token.

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Identity of the account | [AuthenticatedUserResource](#schema-authenticateduserresource) |
| 401 | Missing, invalid or expired access token | [ErrorResource](#schema-errorresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/authentication/me' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/activity-users/{activityUserId}`

Get activity assignment by ID

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `activityUserId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Activity assignment found | [ActivityUserResource](#schema-activityuserresource) |
| 404 | Activity assignment not found | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/activity-users/1' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/activity-users/quest-user/{questUserId}`

Get all activity assignments for a quest user

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `questUserId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Activity assignments retrieved successfully | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/activity-users/quest-user/1' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/activity-users/quest-user/{questUserId}/activity/{activityId}`

Get a quest user's assignment for an activity

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `questUserId` | path | Sí | `integer` | — |
| `activityId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Activity assignment found | [ActivityUserResource](#schema-activityuserresource) |
| 404 | Activity assignment not found | `object` |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/activity-users/quest-user/1/activity/1' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/activities/quest/{questId}`

Get all activities from one quest

Retrieves all available activities in a quest.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `questId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | Activities retrieved succesfully. | array de [ActivityResponse](#schema-activityresponse) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/activities/quest/1' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/achievement`

TS-006: browse achievement definitions

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `scope` | query | No | `string` | INDIVIDUAL, FAMILY, COMMUNITY |
| `page` | query | No | `integer` | — |
| `size` | query | No | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [AchievementResource](#schema-achievementresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/achievement' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/Community/Memberships`

membershipsByUser

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [CommunityMembershipResource](#schema-communitymembershipresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/Community/Memberships' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/Community/Communities`

search_1

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `type` | query | No | `string` | — |
| `locality` | query | No | `string` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [Community](#schema-community) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/Community/Communities' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/Community/Communities/{communityId}/AchievementPosts`

find_1

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `communityId` | path | Sí | `integer` | — |
| `authorId` | query | No | `integer` | — |
| `awardId` | query | No | `string` | — |
| `page` | query | No | `integer` | — |
| `size` | query | No | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [AchievementPostResource](#schema-achievementpostresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/Community/Communities/1/AchievementPosts' -H 'Authorization: Bearer <token>'
```

## GET `/api/v1/Community/Achievements`

list_5

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `community_id` | query | No | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | array de [CommunityAchievementResource](#schema-communityachievementresource) |

Ejemplo de invocación:

```sh
curl -X GET 'http://localhost:8093/api/v1/Community/Achievements' -H 'Authorization: Bearer <token>'
```

## DELETE `/api/v1/family_user/{id}`

Remove a member from a family

Removes the membership with the given id. Only a parent of that family can do it, and a parent cannot remove themselves.

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `id` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 204 | Member removed | Sin cuerpo |
| 403 | The requester is not a parent of the family | [ErrorResource](#schema-errorresource) |
| 404 | The membership does not exist | [ErrorResource](#schema-errorresource) |
| 422 | A parent tried to remove themselves | [ErrorResource](#schema-errorresource) |

Ejemplo de invocación:

```sh
curl -X DELETE 'http://localhost:8093/api/v1/family_user/1' -H 'Authorization: Bearer <token>'
```

## DELETE `/api/v1/collaborative-quests/{sessionId}`

Delete a pending collaborative quest session

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `sessionId` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 204 | Collaborative quest session deleted successfully | `object` |
| 404 | Session not found | `object` |
| 422 | Session cannot be deleted | `object` |

Ejemplo de invocación:

```sh
curl -X DELETE 'http://localhost:8093/api/v1/collaborative-quests/1' -H 'Authorization: Bearer <token>'
```

## DELETE `/api/v1/Community/Posts/{id}`

delete_1

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `id` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X DELETE 'http://localhost:8093/api/v1/Community/Posts/1' -H 'Authorization: Bearer <token>'
```

## DELETE `/api/v1/Community/Events/{id}`

delete_2

| Parámetro | Ubicación | Obligatorio | Tipo | Valores |
|---|---|---|---|---|
| `id` | path | Sí | `integer` | — |

| Código HTTP | Descripción | Cuerpo |
|---|---|---|
| 200 | OK | `object` |

Ejemplo de invocación:

```sh
curl -X DELETE 'http://localhost:8093/api/v1/Community/Events/1' -H 'Authorization: Bearer <token>'
```

# Esquemas JSON

<a id="schema-updateuserprofileresource"></a>
## UpdateUserProfileResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `streak` | `integer` | Sí | {"format": "int32", "minimum": 0} |
| `lastStreakDate` | `['string', 'null']` | No | {"format": "date"} |
| `ecopoints` | `integer` | Sí | {"format": "int32", "minimum": 0} |
| `gemBalance` | `integer` | Sí | {"format": "int32", "minimum": 0} |

<a id="schema-userprofileresource"></a>
## UserProfileResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `name` | `string` | No | — |
| `socialRole` | `string` | No | {"enum": ["STUDENT", "PARENT"]} |
| `streak` | `integer` | No | {"format": "int32"} |
| `lastStreakDate` | `string` | No | {"format": "date"} |
| `ecopoints` | `integer` | No | {"format": "int64"} |
| `gemBalance` | `integer` | No | {"format": "int32"} |
| `equippedCosmeticId` | `['integer', 'null']` | No | {"format": "int64"} |

<a id="schema-errorresource"></a>
## ErrorResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `code` | `string` | No | — |
| `message` | `string` | No | — |
| `details` | `string` | No | — |

<a id="schema-updatequestrequest"></a>
## UpdateQuestRequest

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `minigameId` | `integer` | No | {"format": "int64"} |
| `title` | `string` | Sí | {"minLength": 1} |
| `description` | `string` | Sí | — |
| `category` | `string` | Sí | {"enum": ["WATER", "RECYCLE", "ENERGY"]} |
| `type` | `string` | Sí | {"enum": ["COLLABORATIVE", "MINIGAME", "ACTIVITIES", "DAILY_QUEST", "FAMILY"]} |
| `gemReward` | `integer` | Sí | {"format": "int32"} |
| `ecopoints` | `integer` | Sí | {"format": "int32"} |
| `age` | `integer` | No | {"format": "int32"} |
| `time` | `integer` | No | {"format": "int32"} |
| `theme` | `string` | Sí | {"enum": ["CHECKBOX", "MINIGAME", "COLLABORATIVE"]} |
| `assignedDate` | `string` | No | {"format": "date"} |
| `image` | `string` | No | — |

<a id="schema-questresponse"></a>
## QuestResponse

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `versionGroupId` | `integer` | No | {"format": "int64"} |
| `versionNumber` | `integer` | No | {"format": "int32"} |
| `publicationStatus` | `string` | No | {"enum": ["DRAFT", "PUBLISHED", "ARCHIVED"]} |
| `minigameId` | `integer` | No | {"format": "int64"} |
| `title` | `string` | No | {"minLength": 1, "maxLength": 100} |
| `description` | `string` | No | {"minLength": 1, "maxLength": 255} |
| `category` | `string` | No | {"enum": ["WATER", "RECYCLE", "ENERGY"], "minLength": 1, "maxLength": 50} |
| `type` | `string` | No | {"enum": ["COLLABORATIVE", "MINIGAME", "ACTIVITIES", "DAILY_QUEST", "FAMILY"], "minLength": 1, "maxLength": 50} |
| `gemReward` | `integer` | No | {"format": "int32"} |
| `ecopoints` | `integer` | No | {"format": "int32"} |
| `age` | `integer` | No | {"format": "int32"} |
| `time` | `integer` | No | {"format": "int32"} |
| `theme` | `string` | No | {"enum": ["CHECKBOX", "MINIGAME", "COLLABORATIVE"]} |
| `assignedDate` | `string` | No | {"format": "date"} |
| `image` | `string` | No | {"minLength": 1, "maxLength": 255} |

<a id="schema-respondfriendrequestresource"></a>
## RespondFriendRequestResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `accepted` | `boolean` | Sí | — |

<a id="schema-friendresource"></a>
## FriendResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `requesterId` | `integer` | No | {"format": "int64"} |
| `receiverId` | `integer` | No | {"format": "int64"} |
| `status` | `string` | No | {"enum": ["PENDING", "ACCEPTED", "REJECTED"]} |

<a id="schema-familyplanitemrequestresource"></a>
## FamilyPlanItemRequestResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `questId` | `integer` | Sí | {"format": "int64"} |

<a id="schema-updatefamilyplanresource"></a>
## UpdateFamilyPlanResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `items` | array de [FamilyPlanItemRequestResource](#schema-familyplanitemrequestresource) | No | — |

<a id="schema-updateactivityrequest"></a>
## UpdateActivityRequest

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `description` | `string` | No | — |
| `order` | `integer` | Sí | {"format": "int32"} |
| `type` | `string` | Sí | {"enum": ["CHECKBOX", "WRITE"]} |
| `activityConfiguration` | `['object', 'null']` | No | — |
| `image` | `string` | No | — |

<a id="schema-activityresponse"></a>
## ActivityResponse

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `questId` | `integer` | No | {"format": "int64"} |
| `description` | `string` | No | — |
| `order` | `integer` | No | {"format": "int32"} |
| `type` | `string` | No | {"enum": ["CHECKBOX", "WRITE"]} |
| `activityConfiguration` | `['object', 'null']` | No | — |
| `image` | `string` | No | — |

<a id="schema-createquestrequest"></a>
## CreateQuestRequest

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `minigameId` | `integer` | No | {"format": "int64"} |
| `title` | `string` | Sí | {"minLength": 1, "maxLength": 100} |
| `description` | `string` | No | {"minLength": 1, "maxLength": 255} |
| `category` | `string` | Sí | {"enum": ["WATER", "RECYCLE", "ENERGY"], "minLength": 1, "maxLength": 50} |
| `type` | `string` | Sí | {"enum": ["COLLABORATIVE", "MINIGAME", "ACTIVITIES", "DAILY_QUEST", "FAMILY"], "minLength": 1, "maxLength": 50} |
| `gemReward` | `integer` | Sí | {"format": "int32"} |
| `ecopoints` | `integer` | Sí | {"format": "int32"} |
| `age` | `integer` | No | {"format": "int32"} |
| `time` | `integer` | No | {"format": "int32"} |
| `theme` | `string` | Sí | {"enum": ["CHECKBOX", "MINIGAME", "COLLABORATIVE"]} |
| `assignedDate` | `string` | No | {"format": "date"} |
| `image` | `string` | No | {"minLength": 1, "maxLength": 255} |

<a id="schema-createquestuserrequest"></a>
## CreateQuestUserRequest

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `questId` | `integer` | Sí | {"format": "int64"} |
| `collaborativeSessionId` | `integer` | No | {"format": "int64"} |

<a id="schema-questuserresponse"></a>
## QuestUserResponse

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `userId` | `integer` | No | {"format": "int64"} |
| `questId` | `integer` | No | {"format": "int64"} |
| `status` | `string` | No | {"enum": ["READY_TO_COMPLETE", "IN_PROGRESS", "COMPLETED", "EXPIRED", "CANCELLED"]} |
| `progress` | `number` | No | {"format": "double"} |
| `endDate` | `string` | No | {"format": "date"} |
| `collaborativeSessionId` | `integer` | No | {"format": "int64"} |

<a id="schema-createstreakprotectorresource"></a>
## CreateStreakProtectorResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `name` | `string` | Sí | {"minLength": 0, "maxLength": 120} |
| `description` | `string` | Sí | {"minLength": 0, "maxLength": 500} |
| `priceInGems` | `integer` | No | {"format": "int32"} |

<a id="schema-streakprotectorresource"></a>
## StreakProtectorResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `string` | No | {"format": "uuid"} |
| `name` | `string` | No | — |
| `description` | `string` | No | — |
| `priceInGems` | `integer` | No | {"format": "int32"} |

<a id="schema-createmultiplierresource"></a>
## CreateMultiplierResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `name` | `string` | Sí | {"minLength": 0, "maxLength": 120} |
| `description` | `string` | Sí | {"minLength": 0, "maxLength": 500} |
| `factor` | `number` | Sí | {"minimum": 1.0} |
| `durationMinutes` | `integer` | No | {"format": "int32"} |
| `priceInGems` | `integer` | No | {"format": "int32"} |

<a id="schema-multiplierresource"></a>
## MultiplierResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `string` | No | {"format": "uuid"} |
| `name` | `string` | No | — |
| `description` | `string` | No | — |
| `factor` | `number` | No | — |
| `durationMinutes` | `integer` | No | {"format": "int32"} |
| `priceInGems` | `integer` | No | {"format": "int32"} |

<a id="schema-buyitemresource"></a>
## BuyItemResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `itemId` | `string` | Sí | {"format": "uuid"} |
| `requestId` | `string` | Sí | {"format": "uuid"} |

<a id="schema-ownedprotectorresource"></a>
## OwnedProtectorResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `string` | No | {"format": "uuid"} |
| `protectorId` | `string` | No | {"format": "uuid"} |
| `quantity` | `integer` | No | {"format": "int32"} |

<a id="schema-ownedmultiplierresource"></a>
## OwnedMultiplierResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `string` | No | {"format": "uuid"} |
| `multiplierId` | `string` | No | {"format": "uuid"} |
| `factor` | `number` | No | — |
| `startsAt` | `string` | No | {"format": "date-time"} |
| `expiresAt` | `string` | No | {"format": "date-time"} |

<a id="schema-creategempurchaseresource"></a>
## CreateGemPurchaseResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `packageId` | `string` | Sí | {"format": "uuid"} |
| `paymentMethod` | `string` | Sí | {"enum": ["CARD", "YAPE", "PAYPAL"]} |
| `requestId` | `string` | Sí | {"format": "uuid"} |

<a id="schema-gempurchaseresource"></a>
## GemPurchaseResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `string` | No | {"format": "uuid"} |
| `packageId` | `string` | No | {"format": "uuid"} |
| `gemAmount` | `integer` | No | {"format": "int32"} |
| `amountPaid` | `number` | No | — |
| `currency` | `string` | No | — |
| `paymentMethod` | `string` | No | {"enum": ["CARD", "YAPE", "PAYPAL"]} |
| `paymentStatus` | `string` | No | {"enum": ["PENDING", "APPROVED", "REJECTED"]} |
| `paymentReference` | `string` | No | — |
| `createdAt` | `string` | No | {"format": "date-time"} |
| `completedAt` | `string` | No | {"format": "date-time"} |

<a id="schema-paygempurchaseresource"></a>
## PayGemPurchaseResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `sourceToken` | `string` | Sí | {"minLength": 1} |
| `email` | `string` | Sí | {"format": "email", "minLength": 1} |

<a id="schema-ownedcosmeticresource"></a>
## OwnedCosmeticResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `string` | No | {"format": "uuid"} |
| `cosmeticId` | `string` | No | {"format": "uuid"} |
| `equipped` | `boolean` | No | — |

<a id="schema-creategempackageresource"></a>
## CreateGemPackageResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `name` | `string` | Sí | {"minLength": 0, "maxLength": 120} |
| `gemAmount` | `integer` | No | {"format": "int32"} |
| `price` | `number` | Sí | — |
| `currency` | `string` | Sí | {"minLength": 1, "pattern": "(?i)[A-Z]{3}"} |

<a id="schema-gempackageresource"></a>
## GemPackageResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `string` | No | {"format": "uuid"} |
| `name` | `string` | No | — |
| `gemAmount` | `integer` | No | {"format": "int32"} |
| `price` | `number` | No | — |
| `currency` | `string` | No | — |

<a id="schema-createcosmeticresource"></a>
## CreateCosmeticResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `name` | `string` | Sí | {"minLength": 0, "maxLength": 120} |
| `description` | `string` | Sí | {"minLength": 0, "maxLength": 500} |
| `priceInGems` | `integer` | No | {"format": "int32"} |
| `type` | `string` | Sí | {"minLength": 1} |
| `imageUrl` | `string` | Sí | {"minLength": 0, "maxLength": 500} |

<a id="schema-cosmeticresource"></a>
## CosmeticResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `string` | No | {"format": "uuid"} |
| `name` | `string` | No | — |
| `description` | `string` | No | — |
| `priceInGems` | `integer` | No | {"format": "int32"} |
| `type` | `string` | No | — |
| `imageReference` | `string` | No | — |

<a id="schema-createminigamerequest"></a>
## CreateMinigameRequest

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `name` | `string` | Sí | {"minLength": 1} |
| `description` | `string` | No | — |
| `url` | `string` | Sí | {"minLength": 1} |
| `completionRules` | `object` | Sí | — |

<a id="schema-createminigameattemptrequest"></a>
## CreateMinigameAttemptRequest

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `questId` | `integer` | Sí | {"format": "int64"} |

<a id="schema-minigameattemptresource"></a>
## MinigameAttemptResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `userId` | `integer` | No | {"format": "int64"} |
| `questId` | `integer` | No | {"format": "int64"} |
| `score` | `integer` | No | {"format": "int32"} |
| `status` | `string` | No | {"enum": ["STARTED", "COMPLETED", "CANCELLED"]} |
| `startDate` | `string` | No | {"format": "date-time"} |
| `endDate` | `string` | No | {"format": "date-time"} |
| `metadata` | `object` | No | — |
| `successful` | `boolean` | No | — |

<a id="schema-finishminigameattemptresource"></a>
## FinishMinigameAttemptResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `score` | `integer` | Sí | {"format": "int32"} |
| `metadata` | `object` | No | — |

<a id="schema-shareachievementresource"></a>
## ShareAchievementResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `requestId` | `string` | Sí | {"format": "uuid"} |
| `awardId` | `string` | Sí | {"format": "uuid"} |
| `communityId` | `integer` | Sí | {"format": "int64"} |

<a id="schema-sendfriendrequestresource"></a>
## SendFriendRequestResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `receiverId` | `integer` | Sí | {"format": "int64"} |

<a id="schema-addfamilymemberresource"></a>
## AddFamilyMemberResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `familyId` | `integer` | Sí | {"format": "int64"} |
| `userId` | `integer` | Sí | {"format": "int64"} |
| `familyRole` | `string` | Sí | {"enum": ["PARENT", "CHILD"], "minLength": 1, "pattern": "PARENT|CHILD"} |

<a id="schema-familymemberresource"></a>
## FamilyMemberResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `familyId` | `integer` | No | {"format": "int64"} |
| `userId` | `integer` | No | {"format": "int64"} |
| `familyRole` | `string` | No | {"enum": ["PARENT", "CHILD"]} |

<a id="schema-familyresource"></a>
## FamilyResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `name` | `string` | No | — |
| `commitment` | `string` | No | — |
| `members` | array de [FamilyMemberResource](#schema-familymemberresource) | No | — |

<a id="schema-createfamilyresource"></a>
## CreateFamilyResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `name` | `string` | Sí | {"minLength": 0, "maxLength": 150} |
| `commitment` | `string` | Sí | {"minLength": 0, "maxLength": 255} |

<a id="schema-createfamilyplanresource"></a>
## CreateFamilyPlanResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `familyId` | `integer` | Sí | {"format": "int64"} |
| `items` | array de [FamilyPlanItemRequestResource](#schema-familyplanitemrequestresource) | No | — |

<a id="schema-createcollabquestsessionrequest"></a>
## CreateCollabQuestSessionRequest

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `questId` | `integer` | Sí | {"format": "int64"} |

<a id="schema-collabquestsessionresource"></a>
## CollabQuestSessionResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `questId` | `integer` | No | {"format": "int64"} |
| `ownerUserId` | `integer` | No | {"format": "int64"} |
| `status` | `string` | No | — |
| `createdAt` | `string` | No | {"format": "date-time"} |
| `startedAt` | `string` | No | {"format": "date"} |
| `completedAt` | `string` | No | {"format": "date"} |

<a id="schema-invitecollabquestmemberrequest"></a>
## InviteCollabQuestMemberRequest

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `sessionId` | `integer` | Sí | {"format": "int64"} |
| `invitedUserId` | `integer` | Sí | {"format": "int64"} |

<a id="schema-collabquestmemberresource"></a>
## CollabQuestMemberResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `sessionId` | `integer` | No | {"format": "int64"} |
| `userId` | `integer` | No | {"format": "int64"} |
| `ownerId` | `integer` | No | {"format": "int64"} |
| `role` | `string` | No | {"enum": ["OWNER", "PARTICIPANT"]} |
| `status` | `string` | No | {"enum": ["ACCEPTED", "REJECTED", "PENDING", "LEFT"]} |
| `answerDate` | `string` | No | {"format": "date-time"} |
| `revokeDate` | `string` | No | {"format": "date-time"} |

<a id="schema-verifyemailresource"></a>
## VerifyEmailResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `email` | `string` | Sí | {"format": "email", "minLength": 1} |
| `code` | `string` | Sí | {"minLength": 1, "pattern": "\\d{6}"} |

<a id="schema-authenticateduserresource"></a>
## AuthenticatedUserResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `accountId` | `integer` | No | {"format": "int64"} |
| `email` | `string` | No | — |

<a id="schema-submitregistrationresource"></a>
## SubmitRegistrationResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `name` | `string` | Sí | {"minLength": 2, "maxLength": 120} |
| `email` | `string` | Sí | {"format": "email", "minLength": 0, "maxLength": 255} |
| `password` | `string` | Sí | {"minLength": 0, "maxLength": 72} |
| `socialRole` | `string` | Sí | {"enum": ["STUDENT", "PARENT"], "minLength": 1, "pattern": "STUDENT|PARENT"} |

<a id="schema-pendingregistrationresource"></a>
## PendingRegistrationResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `email` | `string` | No | — |
| `expiresAt` | `string` | No | {"format": "date-time"} |

<a id="schema-signinresource"></a>
## SignInResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `email` | `string` | Sí | {"minLength": 1} |
| `password` | `string` | Sí | {"minLength": 1} |

<a id="schema-authenticationresource"></a>
## AuthenticationResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `accessToken` | `string` | No | — |
| `expiresAt` | `string` | No | {"format": "date-time"} |
| `accountId` | `integer` | No | {"format": "int64"} |
| `email` | `string` | No | — |

<a id="schema-passwordrecoveryresource"></a>
## PasswordRecoveryResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `email` | `string` | Sí | {"format": "email", "minLength": 1} |

<a id="schema-messageresource"></a>
## MessageResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `message` | `string` | No | — |

<a id="schema-confirmpasswordrecoveryresource"></a>
## ConfirmPasswordRecoveryResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `token` | `string` | Sí | {"minLength": 1} |
| `newPassword` | `string` | Sí | {"minLength": 0, "maxLength": 72} |

<a id="schema-createactivityuserrequest"></a>
## CreateActivityUserRequest

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `questUserId` | `integer` | Sí | {"format": "int64"} |
| `activityId` | `integer` | Sí | {"format": "int64"} |
| `collaborativeSessionId` | `integer` | No | {"format": "int64"} |

<a id="schema-activityuserresource"></a>
## ActivityUserResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `questUserId` | `integer` | No | {"format": "int64"} |
| `activityId` | `integer` | No | {"format": "int64"} |
| `progress` | `number` | No | {"format": "double"} |
| `endDate` | `string` | No | {"format": "date"} |
| `activityDescription` | `string` | No | — |
| `activityConfiguration` | `object` | No | — |
| `collaborativeSessionId` | `integer` | No | {"format": "int64"} |

<a id="schema-submitactivityuserresource"></a>
## SubmitActivityUserResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `data` | `object` | Sí | — |

<a id="schema-createactivityrequest"></a>
## CreateActivityRequest

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `questId` | `integer` | Sí | {"format": "int64"} |
| `description` | `string` | No | — |
| `order` | `integer` | Sí | {"format": "int32"} |
| `type` | `string` | Sí | {"enum": ["CHECKBOX", "WRITE"]} |
| `activityConfiguration` | `['object', 'null']` | No | — |
| `image` | `string` | No | — |

<a id="schema-createpostresource"></a>
## CreatePostResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `community_id` | `integer` | Sí | {"format": "int64"} |
| `content` | `string` | Sí | {"minLength": 1} |
| `image_url` | `['string', 'null']` | No | — |

<a id="schema-createpostreactionresource"></a>
## CreatePostReactionResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `post_id` | `integer` | Sí | {"format": "int64"} |
| `reaction_type` | `string` | Sí | {"enum": ["like", "funny", "love", "surprise", "sad", "angry"], "minLength": 1} |

<a id="schema-createevent"></a>
## CreateEvent

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `community_id` | `integer` | Sí | {"format": "int64"} |
| `name` | `string` | Sí | {"minLength": 1} |
| `description` | `string` | No | — |
| `date` | `string` | Sí | {"format": "date"} |
| `start_time` | `string` | Sí | — |
| `location` | `string` | No | — |
| `latitude` | `number` | No | {"format": "double"} |
| `longitude` | `number` | No | {"format": "double"} |
| `capacity` | `integer` | Sí | {"format": "int32"} |
| `image_url` | `string` | No | — |

<a id="schema-createeventregistrationresource"></a>
## CreateEventRegistrationResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `registration_type` | `string` | Sí | {"enum": ["INDIVIDUAL", "FAMILY"]} |
| `family_id` | `['integer', 'null']` | No | {"format": "int64"} |

<a id="schema-createcommunitygoalresource"></a>
## CreateCommunityGoalResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `community_id` | `integer` | Sí | {"format": "int64"} |
| `topic` | `string` | Sí | {"enum": ["water", "energy", "recycle"]} |
| `target` | `integer` | Sí | {"format": "int32"} |

<a id="schema-createtopiccommunityresource"></a>
## CreateTopicCommunityResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `name` | `string` | Sí | {"minLength": 1} |
| `description` | `string` | No | — |
| `topic` | `string` | Sí | {"minLength": 1} |
| `member_limit` | `integer` | Sí | {"format": "int32"} |
| `icon_url` | `string` | No | — |

<a id="schema-createlocalcommunityresource"></a>
## CreateLocalCommunityResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `name` | `string` | Sí | {"minLength": 1} |
| `description` | `string` | No | — |
| `locality` | `string` | Sí | {"minLength": 1} |
| `icon_url` | `string` | No | — |

<a id="schema-updatepostreactiontyperesource"></a>
## UpdatePostReactionTypeResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `reaction_type` | `string` | Sí | {"enum": ["like", "funny", "love", "surprise", "sad", "angry"], "minLength": 1} |

<a id="schema-questuserversionstatusresponse"></a>
## QuestUserVersionStatusResponse

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `questUserId` | `integer` | No | {"format": "int64"} |
| `upToDate` | `boolean` | No | — |
| `missingActivityIds` | array de `integer` | No | — |
| `outdatedActivityIds` | array de `integer` | No | — |

<a id="schema-storecatalogresource"></a>
## StoreCatalogResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `cosmetics` | array de [CosmeticResource](#schema-cosmeticresource) | No | — |
| `multipliers` | array de [MultiplierResource](#schema-multiplierresource) | No | — |
| `streakProtectors` | array de [StreakProtectorResource](#schema-streakprotectorresource) | No | — |
| `gemPackages` | array de [GemPackageResource](#schema-gempackageresource) | No | — |

<a id="schema-gemwalletresource"></a>
## GemWalletResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `balance` | `integer` | No | {"format": "int32"} |

<a id="schema-gemmovementresource"></a>
## GemMovementResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `string` | No | {"format": "uuid"} |
| `type` | `string` | No | {"enum": ["PURCHASE_DEBIT", "GEM_PURCHASE_CREDIT", "REWARD_CREDIT", "REFUND_CREDIT"]} |
| `origin` | `string` | No | {"enum": ["COSMETIC", "MULTIPLIER", "STREAK_PROTECTOR", "GEM_PACKAGE", "QUEST", "COLLAB_QUEST", "MINIGAME", "ACHIEVEMENT"]} |
| `amount` | `integer` | No | {"format": "int32"} |
| `balanceAfter` | `integer` | No | {"format": "int32"} |
| `occurredAt` | `string` | No | {"format": "date-time"} |

<a id="schema-inventoryresource"></a>
## InventoryResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `cosmetics` | array de [OwnedCosmeticResource](#schema-ownedcosmeticresource) | No | — |
| `protectors` | array de [OwnedProtectorResource](#schema-ownedprotectorresource) | No | — |
| `multipliers` | array de [OwnedMultiplierResource](#schema-ownedmultiplierresource) | No | — |

<a id="schema-minigameresource"></a>
## MinigameResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `name` | `string` | No | — |
| `description` | `string` | No | — |
| `url` | `string` | No | — |
| `completionRules` | `object` | No | — |

<a id="schema-pageresourcerankingtransactionresource"></a>
## PageResourceRankingTransactionResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `items` | array de [RankingTransactionResource](#schema-rankingtransactionresource) | No | — |
| `page` | `integer` | No | {"format": "int32"} |
| `size` | `integer` | No | {"format": "int32"} |
| `hasNext` | `boolean` | No | — |

<a id="schema-rankingtransactionresource"></a>
## RankingTransactionResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `string` | No | {"format": "uuid"} |
| `beneficiaryId` | `integer` | No | {"format": "int64"} |
| `ecopoints` | `integer` | No | {"format": "int64"} |
| `occurredAt` | `string` | No | {"format": "date-time"} |

<a id="schema-pageresourcerankingentryresource"></a>
## PageResourceRankingEntryResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `items` | array de [RankingEntryResource](#schema-rankingentryresource) | No | — |
| `page` | `integer` | No | {"format": "int32"} |
| `size` | `integer` | No | {"format": "int32"} |
| `hasNext` | `boolean` | No | — |

<a id="schema-rankingentryresource"></a>
## RankingEntryResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `beneficiaryId` | `integer` | No | {"format": "int64"} |
| `displayName` | `string` | No | — |
| `totalEcopoints` | `integer` | No | {"format": "int64"} |

<a id="schema-rewardtransactionresource"></a>
## RewardTransactionResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `string` | No | {"format": "uuid"} |
| `sourceType` | `string` | No | — |
| `sourceExecutionId` | `string` | No | {"format": "uuid"} |
| `beneficiaryId` | `integer` | No | {"format": "int64"} |
| `ecopoints` | `integer` | No | {"format": "int64"} |
| `gems` | `integer` | No | {"format": "int32"} |
| `occurredAt` | `string` | No | {"format": "date-time"} |

<a id="schema-userprogressresource"></a>
## UserProgressResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `userId` | `integer` | No | {"format": "int64"} |
| `totalEcopoints` | `integer` | No | {"format": "int64"} |
| `currentStreak` | `integer` | No | {"format": "int32"} |
| `longestStreak` | `integer` | No | {"format": "int32"} |
| `lastActivityDate` | `string` | No | {"format": "date"} |
| `lastProtectedDate` | `string` | No | {"format": "date"} |

<a id="schema-achievementawardresource"></a>
## AchievementAwardResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `string` | No | {"format": "uuid"} |
| `achievementId` | `string` | No | {"format": "uuid"} |
| `scope` | `string` | No | — |
| `beneficiaryId` | `integer` | No | {"format": "int64"} |
| `sourceEventId` | `string` | No | {"format": "uuid"} |
| `awardedAt` | `string` | No | {"format": "date-time"} |
| `communityId` | `integer` | No | {"format": "int64"} |

<a id="schema-achievementresource"></a>
## AchievementResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `string` | No | {"format": "uuid"} |
| `code` | `string` | No | — |
| `name` | `string` | No | — |
| `description` | `string` | No | — |
| `scope` | `string` | No | — |
| `metric` | `string` | No | — |
| `target` | `integer` | No | {"format": "int64"} |
| `active` | `boolean` | No | — |

<a id="schema-familyplanitemresource"></a>
## FamilyPlanItemResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `questId` | `integer` | No | {"format": "int64"} |
| `collaborativeSessionId` | `integer` | No | {"format": "int64"} |
| `progress` | `number` | No | {"format": "double"} |

<a id="schema-familyplanresource"></a>
## FamilyPlanResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `familyId` | `integer` | No | {"format": "int64"} |
| `ownerUserId` | `integer` | No | {"format": "int64"} |
| `status` | `string` | No | {"enum": ["DRAFT", "ACTIVE", "COMPLETED", "CANCELLED"]} |
| `progress` | `number` | No | {"format": "double"} |
| `items` | array de [FamilyPlanItemResource](#schema-familyplanitemresource) | No | — |

<a id="schema-collabquestcountersresource"></a>
## CollabQuestCountersResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `acceptedInvites` | `integer` | No | {"format": "int32"} |
| `pendingInvites` | `integer` | No | {"format": "int32"} |
| `activeInvites` | `integer` | No | {"format": "int32"} |
| `maxInvites` | `integer` | No | {"format": "int32"} |

<a id="schema-collabquestpermissionsresource"></a>
## CollabQuestPermissionsResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `canInvite` | `boolean` | No | — |
| `canStart` | `boolean` | No | — |
| `canAcceptInvitation` | `boolean` | No | — |
| `canLeave` | `boolean` | No | — |
| `canRemoveMembers` | `boolean` | No | — |
| `canDeleteSession` | `boolean` | No | — |

<a id="schema-collabquestsessionstateresource"></a>
## CollabQuestSessionStateResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `session` | [CollabQuestSessionResource](#schema-collabquestsessionresource) | No | — |
| `members` | array de [CollabQuestMemberResource](#schema-collabquestmemberresource) | No | — |
| `currentMember` | [CollabQuestMemberResource](#schema-collabquestmemberresource) | No | — |
| `pendingInvitation` | [CollabQuestMemberResource](#schema-collabquestmemberresource) | No | — |
| `permissions` | [CollabQuestPermissionsResource](#schema-collabquestpermissionsresource) | No | — |
| `counters` | [CollabQuestCountersResource](#schema-collabquestcountersresource) | No | — |
| `unavailableUserIds` | array de `integer` | No | — |
| `source` | `string` | No | {"enum": ["COLLABORATIVE", "FAMILY_PLAN"]} |
| `familyPlanId` | `integer` | No | {"format": "int64"} |
| `familyPlanItemId` | `integer` | No | {"format": "int64"} |

<a id="schema-postresource"></a>
## PostResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `community_id` | `integer` | No | {"format": "int64"} |
| `author_id` | `integer` | No | {"format": "int64"} |
| `content` | `string` | No | — |
| `post_type` | `string` | No | — |
| `image_url` | `string` | No | — |
| `related_event_id` | `integer` | No | {"format": "int64"} |
| `likes` | `integer` | No | {"format": "int64"} |

<a id="schema-postreactionresource"></a>
## PostReactionResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `post_id` | `integer` | No | {"format": "int64"} |
| `user_id` | `integer` | No | {"format": "int64"} |
| `reaction_type` | `string` | No | — |

<a id="schema-communitymembershipresource"></a>
## CommunityMembershipResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `community_id` | `integer` | No | {"format": "int64"} |
| `user_id` | `integer` | No | {"format": "int64"} |
| `role` | `string` | No | {"enum": ["ADMIN", "MEMBER"]} |

<a id="schema-eventresource"></a>
## EventResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `community_id` | `integer` | No | {"format": "int64"} |
| `author_id` | `integer` | No | {"format": "int64"} |
| `name` | `string` | No | — |
| `description` | `string` | No | — |
| `date` | `string` | No | {"format": "date"} |
| `start_time` | `string` | No | — |
| `location` | `string` | No | — |
| `latitude` | `number` | No | {"format": "double"} |
| `longitude` | `number` | No | {"format": "double"} |
| `capacity` | `integer` | No | {"format": "int32"} |
| `image_url` | `string` | No | — |

<a id="schema-eventregistrationresource"></a>
## EventRegistrationResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `event_id` | `integer` | No | {"format": "int64"} |
| `user_id` | `integer` | No | {"format": "int64"} |
| `registration_type` | `string` | No | {"enum": ["INDIVIDUAL", "FAMILY"]} |
| `family_id` | `integer` | No | {"format": "int64"} |
| `participant_count` | `integer` | No | {"format": "int32"} |
| `status` | `string` | No | {"enum": ["REGISTERED", "CANCELLED"]} |

<a id="schema-communitygoalresource"></a>
## CommunityGoalResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `community_id` | `integer` | No | {"format": "int64"} |
| `topic` | `string` | No | {"enum": ["water", "energy", "recycle"]} |
| `title` | `string` | No | — |
| `target` | `integer` | No | {"format": "int32"} |
| `progress` | `integer` | No | {"format": "int32"} |
| `participants` | `integer` | No | {"format": "int32"} |
| `status` | `string` | No | {"enum": ["active", "completed"]} |

<a id="schema-community"></a>
## Community

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `name` | `string` | No | — |
| `description` | `string` | No | — |
| `type` | `string` | No | {"enum": ["local", "topic"]} |
| `topic` | `string` | No | — |
| `locality` | `string` | No | — |
| `member_limit` | `integer` | No | {"format": "int32"} |
| `icon_url` | `string` | No | — |
| `created_by` | `integer` | No | {"format": "int64"} |

<a id="schema-achievementpostresource"></a>
## AchievementPostResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `requestId` | `string` | No | {"format": "uuid"} |
| `awardId` | `string` | No | {"format": "uuid"} |
| `authorId` | `integer` | No | {"format": "int64"} |
| `communityId` | `integer` | No | {"format": "int64"} |
| `publishedAt` | `string` | No | {"format": "date-time"} |

<a id="schema-communityachievementresource"></a>
## CommunityAchievementResource

| Campo | Tipo | Obligatorio | Restricciones |
|---|---|---|---|
| `id` | `integer` | No | {"format": "int64"} |
| `community_id` | `integer` | No | {"format": "int64"} |
| `title` | `string` | No | — |
| `description` | `string` | No | — |
| `community_goal_id` | `integer` | No | {"format": "int64"} |
