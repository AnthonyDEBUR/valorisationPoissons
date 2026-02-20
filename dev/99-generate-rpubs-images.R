# dev/99-generate-rpubs-images.R
# Génération complète du cache d’images pour la vignette offline RPubs

library(valorisationPoissons)
library(ggplot2)
library(cowplot)

yaml_path <- "C:/workspace/gwilenalim/yaml/config.yml"
station   <- "04216050"
n_last    <- 12
code_op   <- 95375

# Dossier où stocker les images de la vignette
fig_dir <- "vignettes/fig-rpubs"
if (!dir.exists(fig_dir)) dir.create(fig_dir, recursive = TRUE)

save_plot <- function(plot, name, w = 11, h = 7) {
  ggsave(
    filename = file.path(fig_dir, name),
    plot = plot, width = w, height = h, dpi = 300, bg = "white"
  )
}

# --- 1. Planche IPR ---
p <- make_ipr_planche(
  yaml_path = yaml_path,
  station   = station,
  n_last    = n_last
)
save_plot(p, "planche_ipr.png")

# --- 2. Planche Habitats ---
p <- make_habitats_peche_planche(
  yaml_path = yaml_path,
  station   = station,
  n_last    = n_last
)
save_plot(p, "planche_habitats.png")

# --- 3. Planche Opérations ---
p <- make_operations_peche_planche(
  yaml_path = yaml_path,
  station   = station,
  n_last    = n_last
)
save_plot(p, "planche_operations.png")

# --- 4. Heatmap Faunistique ---
p <- plot_faune_heatmap(
  yaml_path = yaml_path,
  code_station = station,
  n_last = n_last
)
save_plot(p, "heatmap_faune.png")

# --- 5. Heatmap Habitats seuls ---
p <- plot_habitat_heatmap(
  yaml_path = yaml_path,
  code_station = station,
  annee_debut = 2000,
  annee_fin   = 2025
)
save_plot(p, "heatmap_habitat.png")

# --- 6. Histogrammes conditions ---
save_plot(
  plot_profondeur_histogram(yaml_path, station, 2000, 2025, n_last = n_last),
  "hist_profondeur.png", w = 9, h = 4
)
save_plot(
  plot_surface_pechee_histogram(yaml_path, station, 2000, 2025, n_last = n_last),
  "hist_surface.png", w = 9, h = 4
)
save_plot(
  plot_longueur_pechee_histogram(yaml_path, station, 2000, 2025, n_last = n_last),
  "hist_longueur.png", w = 9, h = 4
)
save_plot(
  plot_largeur_lame_eau_pechee_histogram(yaml_path, station, 2000, 2025, n_last = n_last),
  "hist_largeur.png", w = 9, h = 4
)
save_plot(
  plot_conductivite_pechee_histogram(yaml_path, station, 2000, 2025, n_last = n_last),
  "hist_conductivite.png", w = 9, h = 4
)
save_plot(
  plot_temperature_instantanee_pechee_histogram(yaml_path, station, 2000, 2025, n_last = n_last),
  "hist_temperature.png", w = 9, h = 4
)
save_plot(
  plot_puissance_pechee_histogram(yaml_path, station, 2000, 2025, n_last = n_last),
  "hist_puissance.png", w = 9, h = 4
)

# --- 7. Faciès ---
p <- plot_facies_importance(
  yaml_path = yaml_path,
  code_station = station,
  annee_debut = 2000,
  annee_fin   = 2025,
  n_last = n_last
)
save_plot(p, "hist_facies_importance.png", w = 9, h = 4)

# --- 8. IPR 3×3 ---
p <- ipr_heatmap_3x3(
  yaml_path = yaml_path,
  code_operation = code_op,
  show_axis_titles = TRUE,
  show_axis_text = TRUE
)
save_plot(p, "ipr_3x3.png", w = 6, h = 6)

# --- 9. Planche multi-opérations IPR ---
p <- make_analyse_pop_IPR_planche(
  yaml_path = yaml_path,
  station = station,
  annee_debut = 2000,
  n_last = n_last
)
save_plot(p, "planche_ipr_multi.png")

# --- 10. Guildes écologiques ---
p <- graph_modalites_ipr(text_size = 3.5)
ggsave(
  file.path(fig_dir, "ipr_guildes.png"),
  plot = p,
  width = attr(p, "width"),
  height = attr(p, "height"),
  dpi = 300,
  bg = "white"
)

message("✔ Toutes les images ont été générées dans ", normalizePath(fig_dir))
