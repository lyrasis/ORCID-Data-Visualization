# Network visualization script for rorcid output
# Uses the NetSciX Workshop code by Katherine Ognyanova, www.kateto.net
# with slight modifications/tailoring for ORCID data
# For more information, contact LYRASIS at orcidus@lyrasis.org

# Before running this script, make sure your data are in a
# workable format (nodes and edges)
# Follow data structure in workshop materials:
# https://www.kateto.net/wp-content/uploads/2016/01/NetSciX_2016_Workshop.pdf
# Name nodes and edges files "nodes.csv" and "edges.csv"

# Install the package "igraph"
# The package (www.igraph.org) is maintained by Gabor Csardi and Tamas Nepusz.

install.packages("igraph")

# Load the igraph package'

library(igraph)

# Set the working directory to the folder containing the nodes and edges files:

setwd("C:/Users/folder")

# Load the datasets

nodes <- read.csv("nodes.csv", header=T, as.is=T)
links <- read.csv("edges.csv", header=T, as.is=T)

# Examine the data:
head(nodes)
head(links)
nrow(nodes); length(unique(nodes$id))
nrow(links); nrow(unique(links[,c("from", "to")]))

# Collapse multiple links of the same type between the same two nodes
# by summing their weights, using aggregate() by "from", "to", & "type":
links <- aggregate(links[,3], links[,-3], sum)
links <- links[order(links$from, links$to),]
colnames(links)[4] <- "weight"
rownames(links) <- NULL

# Converting the data to an igraph object:
# The graph.data.frame function, which takes two data frames: 'd' and 'vertices'.
# 'd' describes the edges of the network - it should start with two columns
# containing the source and target node IDs for each network tie.
# 'vertices' should start with a column of node IDs.
# Any additional columns in either data frame are interpreted as attributes.

net <- graph_from_data_frame(d=links, vertices=nodes, directed=T)

# Examine the resulting object:
class(net)
net

# We can look at the nodes, edges, and their attributes:
E(net)
V(net)

plot(net, edge.arrow.size=.4,vertex.label=NA)

# Removing loops from the graph:
net <- simplify(net, remove.multiple = F, remove.loops = T)

# Extract data frames describing nodes and edges:
as_data_frame(net, what="edges")
as_data_frame(net, what="vertices")

# Plotting with igraph: node options (starting with 'vertex.') and edge options
# (starting with 'edge.'). A list of options is available:
?igraph.plotting

# We can set the node & edge options in two ways - one is to specify
# them in the plot() function, as we are doing below.

# Plot with curved edges (edge.curved=.1) and reduce arrow size:
plot(net, edge.arrow.size=.4, edge.curved=.1)

# Set node color to orange and the border color to hex #555555
plot(net, edge.arrow.size=.2, edge.curved=0,
     vertex.color="orange", vertex.frame.color="#555555")

# Other layouts to experiment with

# Randomly placed vertices
l <- layout_randomly(net)
plot(net, layout=l)

# Circle layout
l <- layout_in_circle(net)
plot(net, layout=l)

# 3D sphere layout
l <- layout_on_sphere(net)
plot(net, layout=l)

# By default, igraph uses a layout called layout_nicely which selects
# an appropriate layout algorithm based on the properties of the graph.

# Check out all available layouts in igraph:
?igraph::layout_

# R and igraph offer interactive plotting, mostly helpful for small networks
# If your institution has more than a couple hundred collaborations,
# consider a different layout from the ones above

tkid <- tkplot(net) #tkid is the id of the tkplot
l <- tkplot.getcoords(tkid) # grab the coordinates from tkplot

# Shortest distance to the center indicates higher weight/higher number
# of collaborations

tk_close(tkid, window.close = T)
plot(net, layout=l)
