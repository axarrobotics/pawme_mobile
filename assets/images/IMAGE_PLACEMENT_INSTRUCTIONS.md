# Image Placement Instructions

## Required Images for Health Screen

Please save the following images to this directory (`assets/images/`):

### 1. Dog Line Graphic
- **Filename:** `dog_outline.png`
- **Source:** The dog line drawing you provided (white/transparent background)
- **Path:** `assets/images/dog_outline.png`
- **Usage:** Main dog silhouette shown in health issue cards

### 2. Red Gradient Spot
- **Filename:** `red_gradient_spot.png`
- **Source:** The red radial gradient image you provided
- **Path:** `assets/images/red_gradient_spot.png`
- **Usage:** Overlay on dog graphic to indicate health issue locations

## How to Add Images

1. Save the dog line graphic as `dog_outline.png` in this folder
2. Save the red gradient as `red_gradient_spot.png` in this folder
3. The app will automatically load these images
4. If images are not found, the app will use fallback graphics (custom painted versions)

## Image Specifications

- **Dog Outline:** Should be a transparent PNG with black line art
- **Red Gradient:** Should be a transparent PNG with red radial gradient (darker in center, fading to transparent at edges)
- **Recommended size:** 512x512 pixels or larger for both images

## Fallback Behavior

If the images are not found, the app will:
- Use a custom-painted dog silhouette (simplified version)
- Use a programmatically generated radial gradient for health spots

This ensures the app works even without the images, but the visual quality will be better with the actual graphics.
