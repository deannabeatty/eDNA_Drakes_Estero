library(tidyverse)
library(dplyr)
library(ggsci)
library(scales)
library(ggpubr)
library(ggplot2)
library(ggtext)

# bar plot of seine data with both fish & inverts --------------------------------------------------

DE_2021_seine_summary <- read_csv(file = "summary/DE_2021_seine_summary.csv")

# substitute common name for genus species 
#levels(DE_2021_seine_summary$Species)[levels(DE_2021_seine_summary$Species) == "Staghorn sculpin"] <- "Leptocottus armatus"

DE_2021_seine_summary$Species <- recode(DE_2021_seine_summary$Species, 
                                        "Staghorn sculpin" = "Leptocottus armatus",
                                        "Stickleback" = 'Gasterosteus aculeatus', 
                                        "Pipefish" = 'Syngnathus leptorhynchus',
                                        "midshipman" = "Porichthys notatus",
                                        "arrow goby" = "Clevelandia ios",
                                        "Yellow shore crab" = "Hemigrapsus oregonensis", 
                                        "Green crab" = "Carcinus maenas", 
                                        "Grass shrimp" = "Hippolytidae spp.",
                                        "Crangon" = "Crangon sp.")

# obtain palette from NEJM
mypal <- pal_jco("default")(9)
# plot colors 
show_col(mypal)

# vector of hexidecimal color codes
mypal =  c("#0073C2FF", "#EFC000FF", "#868686FF", "#CD534CFF", "#7AA6DCFF", "#003C67FF", "#8F7700FF",
           "#3B3B3BFF", "#A73030FF") 
names(mypal) <- c("Clevelandia ios", "Porichthys notatus", "Syngnathus leptorhynchus", "Leptocottus armatus",
                  "Gasterosteus aculeatus", "Crangon sp.", "Hippolytidae spp.", "Carcinus maenas", "Hemigrapsus oregonensis" )

# make factor seine character 
DE_2021_seine_summary$Seine <- as.character(DE_2021_seine_summary$Seine)

# plot for A (of A & B figure wrapped with ggarrange)
# remove x-axis labels, title, and ticks
# change size of legend title & font to 18
DE_seine_all_species_A <- ggplot(data = DE_2021_seine_summary, 
aes(x = Seine, y = RelAbund,
    fill = Species)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values = mypal) +
  theme(legend.title = element_text(size=18),
        legend.text = element_text(size =18),
        axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.text=element_text(size=16), 
        axis.title = element_text(size = 16)) +
  ylab("Relative abundance %") +
  xlab("Seine number")

DE_seine_all_species_A

# ggsave("plots/DE_seine_all_species_barplot.png", 
#        dpi = 1000, device = "png", width = 11, height = 8.5, units = "in")

# extract the legend; returns a gtable to use in ggarange below
leg <- get_legend(DE_seine_all_species_A)

# bar plot of fish only ---------------------------------------------------

DE_2021_seine_fish_summary <- read_csv(file = "summary/DE_2021_seine_fish_summary.csv")

# recode common name as genus species name
DE_2021_seine_fish_summary$Species <- recode(DE_2021_seine_fish_summary$Species, 
                                        "Staghorn sculpin" = "Leptocottus armatus",
                                        "Stickleback" = 'Gasterosteus aculeatus', 
                                        "Pipefish" = 'Syngnathus leptorhynchus',
                                        "Midshipman" = "Porichthys notatus",
                                        "Arrow goby" = "Clevelandia ios")

# obtain palette from NEJM
mypal <- pal_jco("default")(9)
# plot colors 
show_col(mypal)

# vector of hexidecimal color codes 
# use the same colors of each species across plots
# vector of hexidecimal color codes
mypal2 =  c("#0073C2FF", "#EFC000FF", "#868686FF", "#CD534CFF", "#7AA6DCFF") 
names(mypal2) <- c("Clevelandia ios", "Porichthys notatus", "Syngnathus leptorhynchus", "Leptocottus armatus",
                  "Gasterosteus aculeatus" )  

# convert factor seine to character
DE_2021_seine_fish_summary$Seine <- as.character(DE_2021_seine_fish_summary$Seine)

DE_seine_all_species_fish_only_B <- ggplot(data = DE_2021_seine_fish_summary, 
                                   aes(x = Seine, y = RelAbund,
                                       fill = Species)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values = mypal2) +
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=18), 
        axis.text=element_text(size=16), 
        axis.title = element_text(size = 16)) +
  ylab("Relative abundance %") +
  xlab("Seine")

DE_seine_all_species_fish_only_B

ggsave("plots/DE_seine_fish_species_barplot.png", 
        dpi = 1000, device = "png", width = 11, height = 8.5, units = "in")

# use ggarange to make figure of two plots above
Fig <- ggarrange(DE_seine_all_species_A, DE_seine_all_species_fish_only_B,
                 labels = c("A", "B"), ncol = 1, nrow = 2, align = "hv", 
                 heights = c(1,1), legend.grob = leg, legend = "right")

Fig
ggsave("plots/DE_seine_species_barplot_wrap.png", 
        dpi = 1000, device = "png", width = 11, height = 8.5, units = "in")

# fish length histograms --------------------------------------------------

DE_2021_seine <- read.csv(file = "clean/DE_2021_seine.csv")

# create data frames for each species & remove unmeasured fish/rows 
Stickleback <- filter(DE_2021_seine, Species == "Stickleback")
Stickleback <- filter(Stickleback, Length_mm != "Unmeasured")
Stickleback$Length_mm <- as.numeric(Stickleback$Length_mm)

Pipefish <- filter(DE_2021_seine, Species == "Pipefish")
Pipefish <- filter(Pipefish, Length_mm != "Unmeasured")
Pipefish$Length_mm <- as.numeric(Pipefish$Length_mm)     

Staghorn <- filter(DE_2021_seine, Species == "Staghorn sculpin")
Staghorn <- filter(Staghorn, Length_mm != "Unmeasured")
Staghorn$Length_mm <- as.numeric(Staghorn$Length_mm)

Midshipman <- filter(DE_2021_seine, Species == "Midshipman")
Midshipman <- filter(Midshipman, Length_mm != "Unmeasured")
Midshipman$Length_mm <- as.numeric(Midshipman$Length_mm)

Arrow <- filter(DE_2021_seine, Species == "Arrow goby")
Arrow <- filter(Arrow, Length_mm != "Unmeasured")
Arrow$Length_mm <- as.numeric(Arrow$Length_mm)

# create histograms using the geom_histogram function of ggplot with count on y-axis            
Stickleback_histogram <- ggplot(Stickleback, aes(Length_mm)) + 
  geom_histogram(stat = "count") + 
  ggtitle("Gasterosteus aculeatus") +
  theme_classic() +
  theme(axis.title.x = element_blank(), 
        axis.text =element_text(size=16), 
        axis.title = element_text(size = 16),
        plot.title = element_text(size=16)) + 
  stat_bin(binwidth = 5, color = "black", fill = "gray") +
  scale_x_continuous(breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100),
                     limits = c(0, 100), oob = scales::oob_keep) 

Pipefish_histogram <- ggplot(Pipefish, aes(Length_mm)) + 
  geom_histogram(stat = "count") +
  stat_bin(binwidth = 4, color = "black", fill = "gray") +
  xlab("Length (mm)") + 
  ggtitle("Syngnathus leptorhynchus") +
  theme_classic() +
  theme(axis.text =element_text(size=16), 
        axis.title = element_text(size = 16),
        plot.title = element_text(size=16)) + 
  scale_x_continuous(breaks = c(0, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220), limits = c(0,220), oob = scales::oob_keep)  

Staghorn_histogram <- ggplot(Staghorn, aes(x = Length_mm)) + 
  geom_histogram(stat = "count") + 
  ggtitle("Leptocottus armatus") +
  theme_classic() +
  theme(axis.title.x = element_blank(), 
        axis.text =element_text(size=16), 
        axis.title = element_text(size = 16),
        plot.title = element_text(size=16)) +   
  stat_bin(binwidth = 3, color = "black", fill = "gray") +
  scale_x_continuous(breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100), limits = c(0,100), oob = scales::oob_keep) 

Midshipman_histogram <- ggplot(Midshipman, aes(Length_mm)) +
  geom_histogram(stat = "count") + 
  ggtitle("Porichthys notatus") +
  theme_classic() +
  theme(axis.title.x = element_blank(), 
        axis.text =element_text(size=16), 
        axis.title = element_text(size = 16),
        plot.title = element_text(size=16)) +
  stat_bin(binwidth = 3, color = "black", fill = "gray") +
  scale_y_continuous(breaks = c(0, 1, 2), limits = c(0, 2)) +
  scale_x_continuous(breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100), limits = c(0, 100), oob = scales::oob_keep)

Arrow_histogram <- ggplot(Arrow, aes(Length_mm)) + 
  geom_bar(width = 1, color = "black", fill = "gray") + 
  ggtitle("Clevelandia ios") + 
  theme_classic() +
  theme(axis.title.x = element_blank(), 
        axis.text =element_text(size=16), 
        axis.title = element_text(size = 16),
        plot.title = element_text(size=16)) +
  scale_x_binned() +
  scale_x_continuous(breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100), limits = c(0, 100), oob = scales::oob_keep) +
  scale_y_continuous(breaks = c(0, 1),limits = c(0, 1)) 

# combined figure of all histograms using count
fish_length_histograms <- ggarrange(Stickleback_histogram, Staghorn_histogram, Midshipman_histogram, Arrow_histogram, Pipefish_histogram, 
                                    ncol = 1, nrow = 5)
fish_length_histograms 

ggsave(fish_length_histograms, file = "plots/fish_length_histograms.png", 
        dpi = 1000, device = "png", width = 11, height = 8.5, units = "in")
