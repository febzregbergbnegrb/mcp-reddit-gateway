---
name: motion-design-video
description: Génère un storyboard et tous les prompts (keyframes Nano Banana + clips Veo first/last frame) pour produire une vidéo motion design on-brand de 25 secondes à partir d'un brief léger. Utiliser quand l'utilisateur veut créer une vidéo motion design IA, des prompts de keyframes, ou des prompts Veo.
---

# Motion Design Video — Générateur de prompts keyframes + Veo

Tu aides l'utilisateur à produire une vidéo motion design **on-brand** via le pipeline suivant :

1. **6 images clés** générées par IA (Nano Banana / Gemini image) aux timestamps 0, 5, 10, 15, 20, 25 s
2. **5 clips vidéo** générés par Veo en mode *first/last frame interpolation* (0→5, 5→10, 10→15, 15→20, 20→25)
3. **Assemblage** au montage (raccords invisibles car chaque clip se termine exactement sur la keyframe suivante)

Ton rôle : transformer un brief léger en **storyboard + 6 prompts de keyframes + 5 prompts vidéo**, prêts à copier-coller.

## Étape 1 — Collecter le brief

Lis d'abord `brand.md` dans ce dossier s'il existe : il contient le profil de marque permanent (couleurs, logo, style). Ne redemande pas ce qui s'y trouve.

Informations nécessaires (demande uniquement ce qui manque, en une seule question groupée) :

- **Marque** : couleurs (codes hex), description du logo, style visuel (flat, 3D, glassmorphism, gradient…), références éventuelles
- **Message** : quel est le but de la vidéo ? (lancement produit, pub, explainer, brand reveal…) Quel est LE message à retenir ?
- **Format** : 16:9 (YouTube/web) ou 9:16 (Reels/TikTok/Shorts) — défaut 16:9
- **CTA final** : texte ou action attendue à la fin

Si l'utilisateur donne un brief même vague, propose un storyboard par défaut plutôt que de multiplier les questions. Il ajustera.

## Étape 2 — Construire le storyboard

Découpe les 25 s en arc narratif :

| Segment | Rôle narratif |
|---|---|
| 0–5 s | **Hook** : capter l'attention, intrigue visuelle, le problème ou la promesse |
| 5–10 s | **Tension / contexte** : développer le problème ou révéler le sujet |
| 10–15 s | **Révélation** : le produit / la solution / le cœur du message |
| 15–20 s | **Bénéfice / démonstration** : pourquoi c'est désirable |
| 20–25 s | **Résolution + CTA** : apaisement visuel, place pour le logo et le CTA |

Présente le storyboard sous forme de tableau : timestamp, description visuelle de la keyframe, mouvement prévu dans le segment qui suit. **Fais valider (ou au moins présente) le storyboard avant de générer les prompts** — c'est moins cher de corriger ici.

## Étape 3 — Générer les 6 prompts de keyframes (Nano Banana)

Règles impératives :

- **Prompts en anglais** (les modèles image performent mieux en anglais)
- **Bloc de cohérence répété à l'identique** dans les 6 prompts : palette exacte (codes hex), style, éclairage, type de rendu. C'est ce bloc qui garantit que les 6 images semblent venir du même univers. Le construire une fois, le coller dans chaque prompt.
- **JAMAIS de texte ni de logo dans les images** : la typo et le logo bavent pendant l'interpolation Veo. Ils seront ajoutés en overlay au montage. À la place, prévoir des **zones de respiration** (espaces vides composés) là où le texte sera posé. Mentionner explicitement `no text, no letters, no words, no logo` dans chaque prompt.
- **Aspect ratio** explicite dans chaque prompt (16:9 ou 9:16)
- Décrire **composition, sujet, position des éléments** précisément : la position des éléments dans la keyframe N et N+1 détermine le mouvement que Veo générera entre les deux. Penser chaque paire de keyframes comme un début/fin de mouvement plausible (un objet qui glisse, une caméra qui avance, des formes qui se réorganisent).

Format de sortie pour chaque keyframe :

```
### Keyframe N — [timestamp]s — [rôle narratif]
[prompt complet en anglais, bloc de cohérence inclus]
```

## Étape 4 — Générer les 5 prompts vidéo (Veo first/last frame)

Règles impératives :

- **Prompts en anglais**
- Décrire **uniquement le mouvement, la caméra et le rythme** — le contenu visuel est déjà dans les deux images fournies. Ne pas re-décrire la scène.
- Vocabulaire utile : `smooth easing`, `camera slowly pushes in / pulls back / pans left`, `elements slide / morph / cascade / assemble`, `seamless transition`, `consistent lighting throughout`
- Préciser le tempo souhaité (ex. `calm and steady` pour le CTA, `dynamic and energetic` pour le hook)
- Rappeler la contrainte de fidélité : `maintain exact colors and shapes from both frames, no new elements appear`
- **Pas d'audio Veo** (incohérent entre clips) : la musique sera posée au montage. Le préciser dans les instructions de génération si la plateforme le permet.

Format de sortie pour chaque clip :

```
### Clip N — [start]s → [end]s
First frame : Keyframe N | Last frame : Keyframe N+1
[prompt de mouvement en anglais]
```

## Étape 5 — Checklist de production

Termine toujours par cette checklist adaptée au projet :

1. Générer les 6 keyframes (Nano Banana) — itérer jusqu'à cohérence parfaite des couleurs entre les 6 ; réutiliser l'image validée N comme référence d'édition pour N+1 si la plateforme le permet
2. Générer les 5 clips Veo en mode first/last frame — utiliser **exactement le même fichier** comme last frame du clip N et first frame du clip N+1 ; prévoir 2–3 prises par clip
3. Si la plateforme ne propose que des clips de 4/6/8 s : prendre 6 s et couper au montage (le raccord se fait sur la keyframe, on peut couper n'importe où avant)
4. Montage (CapCut / DaVinci Resolve) : assembler les 5 clips, ajouter texte + logo en overlay (nets, pas générés), poser une musique unique, exporter
5. Plateformes pour Veo first/last frame : Flow (labs.google/flow), Freepik, Krea, fal.ai, Replicate

## Amélioration continue

Ce skill est itératif. Quand l'utilisateur fait un retour après une production ("les transitions étaient trop rapides", "les couleurs ont dérivé"), propose de mettre à jour ce fichier ou `brand.md` pour capitaliser : ajouter la règle apprise dans la section concernée. Note les apprentissages dans `learnings.md` (à créer au premier retour).
