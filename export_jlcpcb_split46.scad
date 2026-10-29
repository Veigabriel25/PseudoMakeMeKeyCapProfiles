use <MX_DES_Standard.scad>
use <jlcpcb_sprue.scad>
use <jlcpcb_thumb_cap.scad>

// Split 4x6, perfil DES MX normal (1u).
// 12 R1, 12 R2, 10 R3, 2 R3 com dot, 12 R4, 10 thumbs.
// 58 teclas = 6 placas de 9 + 1 placa de 4 (58 não divide por 9).
// Cada `part` é um STL, unido por sprue.
//
//  part | arquivo sugerido           | conteúdo
//   1   | split46-R1-9.stl           | 9x R1
//   2   | split46-R2-9.stl           | 9x R2
//   3   | split46-R3-9.stl           | 9x R3
//   4   | split46-R4-9.stl           | 9x R4
//   5   | split46-thumb-9.stl        | 9x thumb
//   6   | split46-mix-9.stl          | 3x R1, 3x R2, 1x R3, 2x R3 com dot
//   7   | split46-mix-4.stl          | 3x R4 + 1x thumb
//
// Grade 3 colunas. Na mix-9 cada fileira é um tipo.
// Na mix-4: três R4 e o thumb embaixo da primeira.
// Exportar: escolha `part`, F6, F7. Um STL por part.

/* [Export] */
part = 1; // [1:7]
thumb_key_id = 6; // 1u corne, Z neutro. Outros 1u: 7, 13, 14, 16, 17, 18, 19

/* [Sprue] */
pitch = 19.05;
bottom = 17.16;   // base 1u do DES (BottomWidth)
cols = 3;
sprue_d = 0.8;    // mm; se a JLCPCB separar as teclas, suba para 1.0
embed = 1.5;      // quanto o sprue entra na parede (parede = 2 mm)
sprue_z = 1.0;    // altura na saia, longe do dish

module mx_cap(key_id, dot = false) {
    keycap(
        keyID = key_id,
        cutLen = 0,
        Stem = true,
        Dish = true,
        Stab = 0,
        visualizeDish = false,
        crossSection = false,
        homeDot = dot,
        homeRing = false,
        Legends = false
    );
}

module row_key(row, dot = false) {
    if (row == 1)
        rotate([0, 0, 180]) mx_cap(5);
    else if (row == 2)
        mx_cap(2);
    else if (row == 3)
        mx_cap(1, dot);
    else if (row == 4)
        mx_cap(0);
}

// item: [tipo, row, dot]  tipo 0 = fileira, tipo 1 = thumb
function row_n(row, dot, n) = [for (i = [0 : n - 1]) [0, row, dot ? 1 : 0]];
function thumb_n(n) = [for (i = [0 : n - 1]) [1, 0, 0]];

module place_key(item) {
    if (item[0] == 1)
        thumb_mx_cap(thumb_key_id);
    else
        row_key(item[1], item[2] == 1);
}

module cluster(spec) {
    n = len(spec);
    echo("Teclas neste STL", n, "sprue_d", sprue_d);
    union() {
        for (i = [0 : n - 1])
            translate([(i % cols) * pitch, floor(i / cols) * pitch, 0])
                place_key(spec[i]);

        jlc_sprues(n, pitch, bottom, cols, sprue_d, embed, sprue_z);
    }
}

mix9 = concat(
    row_n(1, false, 3),
    row_n(2, false, 3),
    row_n(3, false, 1),
    row_n(3, true, 2)
);
mix4 = concat(row_n(4, false, 3), thumb_n(1));

if (part == 1) {
    echo("STL", "split46-R1-9.stl");
    cluster(row_n(1, false, 9));
} else if (part == 2) {
    echo("STL", "split46-R2-9.stl");
    cluster(row_n(2, false, 9));
} else if (part == 3) {
    echo("STL", "split46-R3-9.stl");
    cluster(row_n(3, false, 9));
} else if (part == 4) {
    echo("STL", "split46-R4-9.stl");
    cluster(row_n(4, false, 9));
} else if (part == 5) {
    echo("STL", "split46-thumb-9.stl");
    cluster(thumb_n(9));
} else if (part == 6) {
    echo("STL", "split46-mix-9.stl");
    cluster(mix9);
} else if (part == 7) {
    echo("STL", "split46-mix-4.stl");
    cluster(mix4);
} else {
    echo("part deve ser de 1 a 7");
}
