##Set working directory

setwd("C:/Users/Robert/Desktop/Lancaster/R_for_Data_Science/ch3_Data_visualisation")
#setwd("YourFilepathHere")  #or use R Projects: see Danielle's code for that.

##Load packages (install "grid" if you don't have it)

library(tidyverse)
#install.packages("grid")
library(grid)

##Load data

MC=read.csv("Gla_MC_coda.csv")

##Create a basic graph of the three formants

MC_basicgraph=ggplot(MC, aes(x=measurement_no, y=f1, group=Stimulus, colour=Stimulus))+
  stat_smooth(aes(y=f1), alpha=0.5, size=0.75)+
  stat_smooth(aes(y=f2), alpha=0.5, size=0.75)+
  stat_smooth(aes(y=f3), alpha=0.5, size=0.75)

MC_basicgraph

##Set up ggplot's general plotting theme, so we can control how *all* of our
##graphs look, without having to copy/paste each time.
##Lots of options for these elements - do play around with them (and google!)

graphtheme=theme(axis.title.x=element_text(size=18),
                 axis.text.x=element_text(colour='black',size=12),
                 axis.text.y=element_text(colour='black',size=12),
                 axis.title.y=element_text(size=16),
                 strip.text=element_text(size=18),
                 legend.title=element_text(size=16),
                 legend.text=element_text(size=16),
                 plot.title=element_text(size=24,colour="black"),
                 panel.background=element_rect(fill="grey92")
                 )

##More complex graph, with annotations, titles, etc.

MC_codagraph=ggplot(MC, aes(x=measurement_no, y=f2, group=Stimulus, lty=Stimulus, colour=Stimulus))+
  stat_smooth(aes(y=f1), alpha=0.5, size=0.75)+
  annotation_custom(grob=textGrob(label="F1", hjust=0, gp=gpar(fontsize=12, fontface=2)), xmin=-1, xmax=-1, ymin=550, ymax=550)+
  stat_smooth(aes(y=f2),alpha=0.5,size=0.75)+
  annotation_custom(grob=textGrob(label="F2", hjust=0, gp=gpar(fontsize=12, fontface=2)), xmin=-1, xmax=-1, ymin=1250, ymax=1250)+
  stat_smooth(aes(y=f3),alpha=0.5,size=0.75)+
  annotation_custom(grob=textGrob(label="F3", hjust=0, gp=gpar(fontsize=12, fontface=2)), xmin=-1, xmax=-1, ymin=2350, ymax=2350)+
  ggtitle("Middle Class Glasgow /r/")+          #add a title - always useful!
  ylab("Frequency (Hz)")+                       #add custom labels to axes
  xlab("Normalised timepoints")+                #set size of the y-axis manually, e.g. in case you want to force it to start from 0
  ylim(0,3200)+
  scale_colour_manual(values=c("blue","red"))+  #manually pick colours, if you don't like the defaults (e.g.: http://sape.inf.usi.ch/quick-reference/ggplot2/colour )
  graphtheme                                    #apply the theme

##View the graph

MC_codagraph

##Create a PDF

ggsave("MC_codagraph.pdf", width=6.5, height=6, device=cairo_pdf)

##Alternative (more clunky) way to write a pdf

pdf("MC_codagraph_2.pdf")
plot(MC_codagraph)
dev.off()

##Create a graph for Working Class /r/, which is weaker than MC /r/ in Glasgow.
##F3 doesn't lower down to meet F2 in WC words.
##This weakens the rhotic percept = much more similar to a plain vowel,
##potentially causing perceptual confusion in hut/hurt type words

##Load the other dataset (sorry the data isn't in the same file!)

WC=read.csv("Gla_WC_coda.csv")

WC_codagraph=ggplot(WC, aes(x=measurement_no, y=f2, group=Stimulus, lty=Stimulus, colour=Stimulus))+
  stat_smooth(aes(y=f1), alpha=0.5, size=0.75)+
  annotation_custom(grob=textGrob(label="F1", hjust=0, gp=gpar(fontsize=12, fontface=2)), xmin=-1, xmax=-1, ymin=550, ymax=550)+
  stat_smooth(aes(y=f2),alpha=0.5,size=0.75)+
  annotation_custom(grob=textGrob(label="F2", hjust=0, gp=gpar(fontsize=12, fontface=2)), xmin=-1, xmax=-1, ymin=1000, ymax=1000)+
  stat_smooth(aes(y=f3),alpha=0.5,size=0.75)+
  annotation_custom(grob=textGrob(label="F3", hjust=0, gp=gpar(fontsize=12, fontface=2)), xmin=-1, xmax=-1, ymin=2500, ymax=2500)+
  ylab("Frequency (Hz)")+
  xlab("Normalised timepoints")+
  ylim(0,3200)+
  ggtitle("Working Class Glasgow /r/")+
  scale_colour_manual(values=c("yellow1","coral"))+  #not the nicest colours, but you can experiment
  graphtheme

WC_codagraph

##You can see that the formants are generally much closer together in WC hut/hurt pairs

ggsave("WC_codagraph.pdf", width=6.5, height=6, device=cairo_pdf)

