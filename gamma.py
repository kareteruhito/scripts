import cv2
import numpy as np
import glob
import os

# ガンマ補正して保存するスクリプト

OUTDIR = "Z:/work/out"
TARGETDIR = "."
HIGHT = 1600
GAMMA = 0.75

x = np.arange(256)
y = (x / 255) ** GAMMA * 255    

def imread_unicode(path, flags=cv2.IMREAD_COLOR):
    """日本語パス対応の imread"""
    # バイナリ読み込み → numpy 変換 → imdecode
    with open(path, "rb") as f:
        data = np.frombuffer(f.read(), np.uint8)
    img = cv2.imdecode(data, flags)
    return img


def imwrite_unicode(path, img, params=None):
    """日本語パス対応の imwrite"""
    # 拡張子からフォーマット推定
    ext = path.split('.')[-1].lower()
    # CV2 の imencode 用の拡張子
    result, encoded = cv2.imencode(f".{ext}", img, params if params else [])

    if not result:
        return False

    # バイナリとして書き込む
    with open(path, "wb") as f:
        encoded.tofile(f)

    return True

if (os.path.exists(TARGETDIR) is False):
    os.makedirs(TARGETDIR)

for f in glob.glob(OUTDIR + "/*.png"):
    im = imread_unicode(f)

    result = np.uint8(cv2.LUT(im, y))

    h, w = im.shape[:2]
    target_h = HIGHT
    target_w = int(w * (target_h / h))

    small = cv2.resize(result, (target_w, target_h), interpolation=cv2.INTER_AREA)

    _, basename = os.path.split(f)
    name, ext = os.path.splitext(basename)
    outfile = os.path.join(TARGETDIR, name+".png")
    print(outfile)
    imwrite_unicode(outfile, small)