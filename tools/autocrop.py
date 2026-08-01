import sys
from PIL import Image, ImageChops
src, dst, margin = sys.argv[1], sys.argv[2], int(sys.argv[3])
im = Image.open(src).convert('RGB')
bg = im.getpixel((2, 2))
diff = ImageChops.difference(im, Image.new('RGB', im.size, bg)).convert('L')
mask = diff.point(lambda p: 255 if p > 14 else 0)
bbox = mask.getbbox()
l, t, r, b = bbox
l = max(0, l - margin); t = max(0, t - margin)
r = min(im.width, r + margin); b = min(im.height, b + margin)
im.crop((l, t, r, b)).save(dst)
print(dst, r - l, b - t)
