#初期化
rm(list = ls())

#ライブラリの読み込み
library(ape)
library(ggtree)
library(tidyverse)
library(RColorBrewer)

#newick形式ファイルの読み込み
tree <- read.tree("data/nwk/drosophia_ref.nwk")
#ラベルのズレを調整
tree$tip.label <- c(
    "D.wil     ",
    "D.ana     ",
    "D.sim     ",
    "D.mel     ",
    "D.yak     ",
    "D.pse     "
)

#描写範囲取得
tree_limit <- plot(tree)$x.lim

#色の指定
cols <- brewer.pal(6, "Pastel1")
color_list <- list(
    "wil" = cols[1],
    "ana" = cols[2],
    "sim" = cols[3],
    "mel" = cols[4],
    "yak" = cols[5],
    "pse" = cols[6]
)

#phyloオブジェクトに色指定の列を追加
color_df <- tibble(
    node=1:(Nnode(tree) + Ntip(tree)),
    #ノードの行はnonで埋める
    color = c("wil","ana","sim","mel","yak","pse",c(rep("non", Nnode(tree))))
    )
tree <- full_join(tree, color_df, by="node")

#描写
g <- ggtree(tree) +
    geom_tiplab(
        #色指定
        aes(fill = color),
        size = 18,
        geom = "label",
        #余白を大きく
        label.padding = unit(0.8, "lines"),
        #枠線無くす
        label.size = 0,
        #角を丸くしない
        label.r =  unit(0, "lines"),
        show.legend = FALSE) +
    #wilの部分をblindにする
    geom_highlight(
        node = 1,fill = "#7e7c7c",
        extend = -28
        ) +
    geom_highlight(
        node = 1,fill = "#7e7c7c",
        extend = 15
        ) + 
    scale_x_continuous(limits = c(0,tree_limit[2]*1.3)) + #描写範囲調整
    scale_fill_manual(values = color_list) #色の調整

#保存
ggsave(
    "output/presentation/drosophila_tree/wilout_ref_tree.pdf",plot = g,
    width = 10.1,height = 10.1)