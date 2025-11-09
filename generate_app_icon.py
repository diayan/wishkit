#!/usr/bin/env python3
"""
App Icon Generator for WishKit
Creates a magic wand with sparkles icon with gradient background
"""

from PIL import Image, ImageDraw
import math

def create_gradient(width, height):
    """Create orange to pink gradient background"""
    image = Image.new('RGB', (width, height))
    draw = ImageDraw.Draw(image)

    # Colors: orange (#FF9500) to pink (#FF2D55)
    start_color = (255, 149, 0)
    end_color = (255, 45, 85)

    for y in range(height):
        # Calculate color for this row
        ratio = y / height
        r = int(start_color[0] + (end_color[0] - start_color[0]) * ratio)
        g = int(start_color[1] + (end_color[1] - start_color[1]) * ratio)
        b = int(start_color[2] + (end_color[2] - start_color[2]) * ratio)

        draw.line([(0, y), (width, y)], fill=(r, g, b))

    return image

def draw_sparkle(draw, cx, cy, size, color=(255, 255, 255, 255)):
    """Draw a four-pointed sparkle star"""
    # Main cross
    points = [
        (cx, cy - size),  # top
        (cx - size//4, cy - size//4),
        (cx - size, cy),  # left
        (cx - size//4, cy + size//4),
        (cx, cy + size),  # bottom
        (cx + size//4, cy + size//4),
        (cx + size, cy),  # right
        (cx + size//4, cy - size//4),
    ]
    draw.polygon(points, fill=color)

    # Add diagonal points for more sparkle
    diag_size = int(size * 0.6)
    diag_offset = int(size * 0.7)
    diag_points = [
        (cx - diag_offset, cy - diag_offset),
        (cx - diag_offset + diag_size//4, cy - diag_offset),
        (cx, cy - diag_size//2),
        (cx, cy - diag_offset + diag_size//4),
    ]

    # Top-left
    draw.polygon(diag_points, fill=color)

    # Top-right (rotate)
    diag_points_tr = [
        (cx + diag_offset, cy - diag_offset),
        (cx + diag_offset, cy - diag_offset + diag_size//4),
        (cx + diag_size//2, cy),
        (cx + diag_offset - diag_size//4, cy),
    ]
    draw.polygon(diag_points_tr, fill=color)

    # Bottom-left
    diag_points_bl = [
        (cx - diag_offset, cy + diag_offset),
        (cx - diag_size//2, cy),
        (cx, cy + diag_offset - diag_size//4),
        (cx - diag_offset + diag_size//4, cy + diag_offset),
    ]
    draw.polygon(diag_points_bl, fill=color)

    # Bottom-right
    diag_points_br = [
        (cx + diag_offset, cy + diag_offset),
        (cx + diag_offset - diag_size//4, cy + diag_offset),
        (cx, cy + diag_size//2),
        (cx, cy + diag_offset - diag_size//4),
    ]
    draw.polygon(diag_points_br, fill=color)

def draw_wand(draw, size):
    """Draw a magic wand"""
    center_x, center_y = size // 2, size // 2

    # Wand stick (diagonal from bottom-left to top-right)
    stick_width = max(int(size * 0.06), 3)

    # Calculate wand endpoints
    stick_length = size * 0.55
    angle = math.radians(45)  # 45 degree angle

    end_x = int(center_x + stick_length * math.cos(angle))
    end_y = int(center_y - stick_length * math.sin(angle))
    start_x = int(center_x - stick_length * 0.3 * math.cos(angle))
    start_y = int(center_y + stick_length * 0.3 * math.sin(angle))

    # Draw wand stick with rounded ends
    draw.line([(start_x, start_y), (end_x, end_y)],
              fill=(255, 255, 255, 255), width=stick_width)

    # Draw circles at ends for rounded effect
    draw.ellipse([start_x - stick_width//2, start_y - stick_width//2,
                  start_x + stick_width//2, start_y + stick_width//2],
                 fill=(255, 255, 255, 255))
    draw.ellipse([end_x - stick_width//2, end_y - stick_width//2,
                  end_x + stick_width//2, end_y + stick_width//2],
                 fill=(255, 255, 255, 255))

    # Draw star at wand tip
    star_size = int(size * 0.12)
    draw_sparkle(draw, end_x, end_y, star_size, (255, 255, 255, 255))

def create_app_icon(size):
    """Create app icon at specified size"""
    # Create gradient background
    image = create_gradient(size, size)

    # Convert to RGBA for transparency support
    image = image.convert('RGBA')

    # Create overlay for drawing
    overlay = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)

    # Draw magic wand
    draw_wand(draw, size)

    # Draw sparkles around the icon
    sparkle_positions = [
        (int(size * 0.2), int(size * 0.25), int(size * 0.08)),  # Small top-left
        (int(size * 0.75), int(size * 0.2), int(size * 0.06)),  # Tiny top-right
        (int(size * 0.25), int(size * 0.75), int(size * 0.07)),  # Small bottom-left
        (int(size * 0.8), int(size * 0.7), int(size * 0.09)),   # Medium bottom-right
    ]

    for x, y, sparkle_size in sparkle_positions:
        draw_sparkle(draw, x, y, sparkle_size, (255, 255, 255, 230))

    # Composite overlay onto background
    image = Image.alpha_composite(image, overlay)

    # Apply corner radius (iOS style)
    mask = Image.new('L', (size, size), 0)
    mask_draw = ImageDraw.Draw(mask)
    # iOS icon corner radius is ~22.37% of size
    corner_radius = int(size * 0.2237)
    mask_draw.rounded_rectangle([(0, 0), (size, size)], radius=corner_radius, fill=255)

    # Apply mask
    output = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    output.paste(image, (0, 0))
    output.putalpha(mask)

    return output

def main():
    """Generate all required iOS app icon sizes"""
    # iOS App Icon sizes (in pixels)
    sizes = {
        '1024': 1024,  # App Store
        '180': 180,    # iPhone @3x
        '120': 120,    # iPhone @2x
        '167': 167,    # iPad Pro @2x
        '152': 152,    # iPad @2x
        '76': 76,      # iPad @1x
        '60': 60,      # iPhone @1x (notification)
        '58': 58,      # Settings @2x
        '87': 87,      # Settings @3x
        '80': 80,      # Spotlight @2x
        '120_spot': 120,  # Spotlight @3x
        '40': 40,      # Spotlight @1x
        '29': 29,      # Settings @1x
        '20': 20,      # Notification @1x
    }

    import os
    output_dir = 'AppIcon'
    os.makedirs(output_dir, exist_ok=True)

    print("Generating WishKit app icons...")
    for name, size in sizes.items():
        icon = create_app_icon(size)
        filename = f'{output_dir}/icon_{size}x{size}.png'
        icon.save(filename, 'PNG')
        print(f'✓ Generated {filename}')

    print(f'\n✅ All icons generated in {output_dir}/ directory')
    print('\nTo use:')
    print('1. Open WishKit.xcodeproj in Xcode')
    print('2. Select Assets.xcassets in the navigator')
    print('3. Click on AppIcon')
    print('4. Drag and drop the generated icons to their respective slots')

if __name__ == '__main__':
    main()
