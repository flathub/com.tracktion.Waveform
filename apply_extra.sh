#!/usr/bin/env bash

set -e

FLATPAK_ID=com.tracktion.Waveform

# Unpack the .deb file
mkdir -p deb-package
ar p waveform12.deb data.tar.xz | tar -xJf - -C deb-package

# Move to export/share
mkdir -p export/share
mv deb-package/usr/bin/Waveform12 waveform12
mv deb-package/usr/share/{applications,doc,mime} export/share/

# Icon
mkdir -p export/share/icons/hicolor/512x512/apps
mv deb-package/usr/share/pixmaps/* export/share/icons/hicolor/512x512/apps

rename "waveform12" "${FLATPAK_ID}" export/share/{applications,mime/packages,icons/hicolor/*/*}/waveform12.*

# Desktop file
desktop-file-edit \
    --set-key="Exec" --set-value="waveform %U" \
    --set-key="Icon" --set-value="${FLATPAK_ID}" \
    --set-key="Categories" --set-value="AudioVideo;AudioVideoEditing;" \
    --set-key="X-Flatpak-RenamedFrom" --set-value="waveform12.desktop;" \
    "export/share/applications/${FLATPAK_ID}.desktop"

# Download manager
ar p tracktion-download-manager.deb data.tar.xz | tar -xJf - -C deb-package
mv deb-package/usr/bin/tracktion-download-manager tracktion-download-manager

rm -r waveform12.deb tracktion-download-manager.deb deb-package
