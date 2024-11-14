# Load necessary libraries
library(textmineR)
library(stopwords)


# Step 1: Load and preprocess data
# Load the dataset
reviews <- read.csv("C:/Users/Shokoufeh/OneDrive/third_semester/Text-Mining/2th_homework/textreviews.csv", stringsAsFactors = FALSE)
reviews$text <- iconv(reviews$text, from = "latin1", to = "UTF-8", sub = "")


# Step 2: Create Document-Term Matrix (DTM) with TF-IDF
# Create a DTM from text data in the dataset
dtm <- CreateDtm(
  doc_vec = reviews$text,            # Document text vector
  doc_names = reviews$id,             # Document IDs as names
  ngram_window = c(1, 2),             # 1-gram and 2-gram
  stopword_vec = stopwords("en"),     # Stopwords in English
  lower = TRUE,                       # Convert to lowercase
  remove_punctuation = TRUE,          # Remove punctuation
  remove_numbers = TRUE               # Remove numbers
)

# Step 3: Compute TF-IDF Matrix
# Develop the term frequency matrix to get IDF vector
tf_mat <- TermDocFreq(dtm)

# Calculate the TF-IDF values
tfidf <- t(dtm[ , tf_mat$term ]) * tf_mat$idf
tfidf <- t(tfidf)
tfidf <- tfidf[rowSums(tfidf) != 0, ]  # add to remove nan rows
# Step 4: Compute Cosine Similarity and Distance
# Compute cosine similarity
csim <- tfidf / sqrt(rowSums(tfidf * tfidf))
csim <- csim %*% t(csim)

# Convert cosine similarity to cosine distance
cdist <- as.dist(1 - csim)

# Step 5: Perform Hierarchical Clustering
# Apply agglomerative hierarchical clustering with Ward's method
hc <- hclust(cdist, method = "ward.D")

# Cut the dendrogram to form clusters (e.g., into 5 clusters)
clustering <- cutree(hc, k = 2)

# Calculate silhouette scores for hierarchical clustering with 2 clusters
sil_hc <- silhouette(clustering, dist(cdist))
mean_silhouette_hc <- mean(sil_hc[, "sil_width"])  # Average silhouette width
# Print average silhouette score
print(paste("Average silhouette score for hierarchical clustering:", mean_silhouette_hc))

# Plot the dendrogram with cluster borders
#plot(hc, main = "Hierarchical Clustering of Product Reviews",
#     xlab = "", ylab = "")
#rect.hclust(hc, k = 2, border = "red")

# Step 6: Interpret and Name Clusters
# Identify characteristic words for each cluster
p_words <- colSums(dtm) / sum(dtm)  # Overall probability of words

cluster_words <- lapply(unique(clustering), function(x) {
  rows <- dtm[clustering == x, ]
  
  # Drop words that do not appear in the cluster for memory efficiency
  rows <- rows[, colSums(rows) > 0]
  
  # Compute the difference in probability for words in the cluster vs. overall
  colSums(rows) / sum(rows) - p_words[colnames(rows)]
})


# create a summary table of the top 5 words defining each cluster
cluster_summary <- data.frame(cluster = unique(clustering),
                              size = as.numeric(table(clustering)),
                              top_words = sapply(cluster_words, function(d){
                                paste(
                                  names(d)[ order(d, decreasing = TRUE) ][ 1:5 ], 
                                  collapse = ", ")
                              }),
                              stringsAsFactors = FALSE)
cluster_summary
# I tryied 20 cluster and 5 cluster and it looks that there was just two kinds of products.
#clothes and game stuf. so I decided to choose two cluster. cluster 1: clothes and cluster 2: game stuff.
#-------------- k-mean--------

# Define a range for k (e.g., from 1 to 10)
wss <- sapply(1:10, function(k) {
  kmeans(cdist, centers = k, nstart = 10)$tot.withinss
})

# Plot the Elbow Curve
plot(1:10, wss, type = "b", pch = 19, frame = FALSE, 
     xlab = "Number of Clusters K",
     ylab = "Total Within-Cluster Sum of Squares (WSS)")
title("Elbow Method for Optimal K")



# Define a range for k (e.g., from 2 to 10)
silhouette_scores <- sapply(2:10, function(k) {
  kmeans_result <- kmeans(cdist, centers = k, nstart = 10)
  silhouette_avg <- mean(silhouette(kmeans_result$cluster, dist(cdist))[, "sil_width"])
  return(silhouette_avg)
})

# Plot the Silhouette Score Curve
plot(2:10, silhouette_scores, type = "b", pch = 19, frame = FALSE,
     xlab = "Number of Clusters K",
     ylab = "Average Silhouette Score")
title("Silhouette Method for Optimal K")



# k means algorithm, 2 clusters, 100 starting configurations
kfit <- kmeans(cdist, 2, nstart=100)

# plot the output
clusplot(as.matrix(cdist), kfit$cluster, color=T, shade=T, labels=2, lines=0)

cluster_summary <- data.frame(cluster = unique(kfit),
                              size = as.numeric(table(kfit)),
                              top_words = sapply(cluster_words, function(d){
                                paste(
                                  names(d)[ order(d, decreasing = TRUE) ][ 1:5 ], 
                                  collapse = ", ")
                              }),
                              stringsAsFactors = FALSE)
cluster_summary

