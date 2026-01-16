/*
  计算文本高度
*/
// 必须加 .pragma library
.pragma library

function calculateTextHeight(text, width, fontPixelSize, maxLines) {
    if (!text || width <= 0)
        return 0

    // QML Text 的经验行高
    var lineHeight = fontPixelSize * 1.2

    // 粗略估算每行字符数（适用于中英混排）
    var avgCharWidth = fontPixelSize * 0.55
    var charsPerLine = Math.floor(width / avgCharWidth)

    if (charsPerLine <= 0)
        return lineHeight

    var lines = Math.ceil(text.length / charsPerLine)
    lines = Math.min(lines, maxLines)

    return lines * lineHeight
}
