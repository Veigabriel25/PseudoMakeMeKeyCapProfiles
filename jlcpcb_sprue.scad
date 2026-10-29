// Sprue curto entre teclas vizinhas. O conjunto vira um sólido só.
// Diâmetro 0,8 mm: fino o bastante para cortar, grosso o bastante para a JLCPCB não separar as peças.
module jlc_sprues(count, pitch = 19.05, bottom = 17.16, cols = 3, sprue_d = 0.8, embed = 1.5, sprue_z = 1.0) {
    span = pitch - bottom + 2 * embed;
    r = sprue_d / 2;

    for (i = [0 : count - 1]) {
        col = i % cols;
        row = floor(i / cols);

        if (col < cols - 1 && i + 1 < count) {
            translate([col * pitch + pitch / 2, row * pitch, sprue_z])
                rotate([0, 90, 0])
                cylinder(h = span, r = r, center = true, $fn = 16);
        }

        if (i + cols < count) {
            translate([col * pitch, row * pitch + pitch / 2, sprue_z])
                rotate([90, 0, 0])
                cylinder(h = span, r = r, center = true, $fn = 16);
        }
    }
}
