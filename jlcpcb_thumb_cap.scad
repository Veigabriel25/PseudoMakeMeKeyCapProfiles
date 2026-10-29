use <MX_DES_Thumb.scad>

// Módulo isolado para o keycap de thumb não substituir o keycap do DES standard.
module thumb_mx_cap(key_id = 6) {
    keycap(
        keyID = key_id,
        cutLen = 0,
        Stem = true,
        Dish = true,
        Stab = 0,
        visualizeDish = false,
        crossSection = false,
        homeDot = false,
        Legends = false
    );
}
