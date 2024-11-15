# Install required packages if not already installed
install.packages(c("tm", "SnowballC", "slam", "topicmodels", "textmineR"))

# Load libraries
library(tm)
library(SnowballC)
library(slam)
library(topicmodels)
library(textmineR)

# Set the path to your text files
text_path <- "C:\\Users\\Shokoufeh\\OneDrive\\third_semester\\Text-Mining\\2th_homework\\text"

# Load and preprocess text files
docs <- VCorpus(DirSource(text_path, encoding = "UTF-8"))
# Create Document-Term Matrix (DTM) with TF-IDF

# Preprocess the texts
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removeWords, stopwords("en"))
docs <- tm_map(docs, stripWhitespace) 
docs <- tm_map(docs, stemDocument)

library(tm)

# Custom content transformer
replace_contractions <- content_transformer(function(x) {
  x <- gsub("'re", " are", x)
  x <- gsub("gonna", "going to", x)
  x <- gsub("theyr", "they are", x)  # Fix errors or typos
  x
})

# Apply to the corpus
docs <- tm_map(docs, replace_contractions)


# Create a Document-Term Matrix (DTM) using TF-IDF weighting
dtm <- DocumentTermMatrix(docs, control = list(weighting = weightTfIdf))

# Remove sparse terms to improve clustering
dtm <- removeSparseTerms(dtm, 0.95)

# Convert DTM to a matrix for clustering
dtm_matrix <- as.matrix(dtm)

# Set the number of clusters
num_clusters <- 2  # Adjust this based on exploration of data

# Perform K-means clustering
set.seed(123)  # For reproducibility
kmeans_result <- kmeans(dtm_matrix, centers = num_clusters)

# Create a summary data frame for each cluster
cluster_summary <- data.frame(
  cluster = unique(kmeans_result$cluster),
  size = as.numeric(table(kmeans_result$cluster)),
  top_words = sapply(1:num_clusters, function(cluster_num) {
    cluster_docs <- dtm_matrix[kmeans_result$cluster == cluster_num, ]
    
    # Ensure cluster_docs is treated as a matrix even if it has only one row
    if (is.vector(cluster_docs)) {
      cluster_docs <- matrix(cluster_docs, nrow = 1)
    }
    
    # Sum terms for the current cluster
    term_sums <- colSums(cluster_docs)
    # Get the top 5 terms for this cluster
    top_terms <- names(sort(term_sums, decreasing = TRUE)[1:5])
    paste(top_terms, collapse = ", ")
  }),
  stringsAsFactors = FALSE
)

# Display the summary
print(cluster_summary)


# based on five top repetition" "’re, flexibl, risk, project, countri"  it looks related
# to the related to country's projects and measuring the risk of that.
#But I know these results are not correct and I hope you will share us the correct clustering 
#and result.


