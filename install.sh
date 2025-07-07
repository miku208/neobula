#!/bin/bash

echo "🚀 Menginstal Tema Neobula dengan Background Kustom dari GitHub..."

# Lokasi default panel Pterodactyl
PANEL_DIR="/var/www/pterodactyl"
THEME_DIR="$PANEL_DIR/public/themes/Neobula"

# Cek direktori panel
if [ ! -d "$PANEL_DIR" ]; then
    echo "❌ Pterodactyl tidak ditemukan di $PANEL_DIR"
    exit 1
fi

# Buat folder tema jika belum ada
mkdir -p "$THEME_DIR/css"

# Download gambar background
echo "📥 Mengunduh gambar background dari GitHub..."
wget -q https://raw.githubusercontent.com/miku208/Img/main/IMG-20250626-WA0197.jpg -O "$THEME_DIR/background.jpg"

# Tulis CSS custom
echo "🎨 Menambahkan CSS background..."
cat > "$THEME_DIR/css/custom.css" <<EOF
body {
    background: url('/themes/Neobula/background.jpg') no-repeat center center fixed;
    background-size: cover;
    background-color: #000;
}
EOF

# Tambahkan referensi CSS ke panel jika belum ada
LAYOUT_FILE="$PANEL_DIR/resources/views/layouts/app.blade.php"
if ! grep -q 'themes/Neobula/css/custom.css' "$LAYOUT_FILE"; then
    echo "🔧 Menyisipkan link CSS di layout panel..."
    sed -i "/<head>/a <link rel=\"stylesheet\" href=\"{{ asset('themes/Neobula/css/custom.css') }}\">" "$LAYOUT_FILE"
fi

# Bersihkan cache
echo "🧹 Membersihkan cache..."
cd "$PANEL_DIR"
php artisan view:clear
php artisan config:clear

# Restart nginx (atau apache jika kamu pakai itu)
systemctl restart nginx

echo "✅ Sukses! Tema Neobula telah dipasang dengan background kustom dari GitHub!"
