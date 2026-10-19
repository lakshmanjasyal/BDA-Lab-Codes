# ==========================================
# APRIORI ALGORITHM
# R 4.1.2 - BASE R ONLY
# NO PACKAGES REQUIRED
# ==========================================

# Transaction data
transactions <- list(
  c("Milk", "Bread", "Butter"),
  c("Bread", "Diaper", "Beer", "Eggs"),
  c("Milk", "Diaper", "Beer", "Coke"),
  c("Bread", "Milk", "Diaper", "Beer"),
  c("Bread", "Milk", "Diaper", "Coke")
)

# Minimum support and confidence
min_support <- 0.4
min_confidence <- 0.6


# ------------------------------------------
# SUPPORT FUNCTION
# ------------------------------------------

calculate_support <- function(itemset, transactions) {
  
  count <- 0
  
  for (transaction in transactions) {
    
    if (all(itemset %in% transaction)) {
      count <- count + 1
    }
  }
  
  return(count / length(transactions))
}


# ------------------------------------------
# GENERATE CANDIDATES
# ------------------------------------------

generate_candidates <- function(items, k) {
  
  if (k == 1) {
    return(as.list(items))
  }
  
  return(combn(items, k, simplify = FALSE))
}


# ------------------------------------------
# APRIORI ALGORITHM
# ------------------------------------------

apriori_base <- function(transactions, min_support) {
  
  all_items <- sort(unique(unlist(transactions)))
  
  frequent_itemsets <- list()
  
  k <- 1
  
  repeat {
    
    candidates <- generate_candidates(all_items, k)
    
    frequent_k <- list()
    
    for (itemset in candidates) {
      
      s <- calculate_support(
        itemset,
        transactions
      )
      
      if (s >= min_support) {
        
        frequent_k[[length(frequent_k) + 1]] <- list(
          items = itemset,
          support = s
        )
      }
    }
    
    if (length(frequent_k) == 0) {
      break
    }
    
    frequent_itemsets[[k]] <- frequent_k
    
    k <- k + 1
    
    if (k > length(all_items)) {
      break
    }
  }
  
  return(frequent_itemsets)
}


# ------------------------------------------
# RUN APRIORI
# ------------------------------------------

frequent_itemsets <- apriori_base(
  transactions,
  min_support
)


# ------------------------------------------
# DISPLAY FREQUENT ITEMSETS
# ------------------------------------------

cat("\n========== FREQUENT ITEMSETS ==========\n")

for (k in 1:length(frequent_itemsets)) {
  
  cat("\nFrequent", k, "-itemsets:\n")
  
  for (itemset in frequent_itemsets[[k]]) {
    
    cat(
      "{",
      paste(itemset$items, collapse = ", "),
      "}  Support = ",
      round(itemset$support * 100, 2),
      "%\n"
    )
  }
}


# ------------------------------------------
# GENERATE ASSOCIATION RULES
# ------------------------------------------

generate_rules <- function(
    frequent_itemsets,
    transactions,
    min_confidence
) {
  
  rules <- list()
  
  rule_number <- 1
  
  if (length(frequent_itemsets) < 2) {
    return(rules)
  }
  
  for (k in 2:length(frequent_itemsets)) {
    
    for (itemset_data in frequent_itemsets[[k]]) {
      
      itemset <- itemset_data$items
      
      n <- length(itemset)
      
      for (r in 1:(n - 1)) {
        
        subsets <- combn(
          itemset,
          r,
          simplify = FALSE
        )
        
        for (lhs in subsets) {
          
          rhs <- setdiff(itemset, lhs)
          
          support_itemset <- calculate_support(
            itemset,
            transactions
          )
          
          support_lhs <- calculate_support(
            lhs,
            transactions
          )
          
          support_rhs <- calculate_support(
            rhs,
            transactions
          )
          
          confidence <- support_itemset / support_lhs
          
          lift <- confidence / support_rhs
          
          if (confidence >= min_confidence) {
            
            rules[[rule_number]] <- list(
              lhs = lhs,
              rhs = rhs,
              support = support_itemset,
              confidence = confidence,
              lift = lift
            )
            
            rule_number <- rule_number + 1
          }
        }
      }
    }
  }
  
  return(rules)
}


# ------------------------------------------
# GENERATE RULES
# ------------------------------------------

rules <- generate_rules(
  frequent_itemsets,
  transactions,
  min_confidence
)


# ------------------------------------------
# DISPLAY RULES
# ------------------------------------------

cat("\n========== ASSOCIATION RULES ==========\n")

if (length(rules) == 0) {
  
  cat("No rules found.\n")
  
} else {
  
  for (i in 1:length(rules)) {
    
    rule <- rules[[i]]
    
    cat(
      "{",
      paste(rule$lhs, collapse = ", "),
      "} => {",
      paste(rule$rhs, collapse = ", "),
      "}\n"
    )
    
    cat(
      "Support = ",
      round(rule$support * 100, 2),
      "%\n"
    )
    
    cat(
      "Confidence = ",
      round(rule$confidence * 100, 2),
      "%\n"
    )
    
    cat(
      "Lift = ",
      round(rule$lift, 3),
      "\n\n"
    )
  }
}


# ==========================================
# PLOT 1: SUPPORT OF FREQUENT ITEMSETS
# ==========================================

itemset_names <- c()
itemset_supports <- c()

for (k in 1:length(frequent_itemsets)) {
  
  for (itemset_data in frequent_itemsets[[k]]) {
    
    itemset_names <- c(
      itemset_names,
      paste(itemset_data$items, collapse = ", ")
    )
    
    itemset_supports <- c(
      itemset_supports,
      itemset_data$support * 100
    )
  }
}


barplot(
  itemset_supports,
  names.arg = itemset_names,
  col = "steelblue",
  main = "Support of Frequent Itemsets",
  xlab = "Itemsets",
  ylab = "Support (%)",
  ylim = c(0, 100),
  las = 2
)

abline(
  h = min_support * 100,
  col = "red",
  lty = 2,
  lwd = 2
)

legend(
  "topright",
  legend = paste(
    "Minimum Support =",
    min_support * 100,
    "%"
  ),
  col = "red",
  lty = 2,
  lwd = 2
)


# ==========================================
# PLOT 2: CONFIDENCE OF ASSOCIATION RULES
# ==========================================

if (length(rules) > 0) {
  
  rule_names <- c()
  rule_confidence <- c()
  
  for (i in 1:length(rules)) {
    
    rule <- rules[[i]]
    
    rule_names <- c(
      rule_names,
      paste(
        "{",
        paste(rule$lhs, collapse = ", "),
        "} => {",
        paste(rule$rhs, collapse = ", "),
        "}"
      )
    )
    
    rule_confidence <- c(
      rule_confidence,
      rule$confidence * 100
    )
  }
  
  
  barplot(
    rule_confidence,
    names.arg = rule_names,
    col = "darkgreen",
    main = "Confidence of Association Rules",
    xlab = "Association Rules",
    ylab = "Confidence (%)",
    ylim = c(0, 100),
    las = 2
  )
  
  abline(
    h = min_confidence * 100,
    col = "red",
    lty = 2,
    lwd = 2
  )
  
  legend(
    "topright",
    legend = paste(
      "Minimum Confidence =",
      min_confidence * 100,
      "%"
    ),
    col = "red",
    lty = 2,
    lwd = 2
  )
}


# ==========================================
# PLOT 3: LIFT OF ASSOCIATION RULES
# ==========================================

if (length(rules) > 0) {
  
  rule_lift <- c()
  
  for (i in 1:length(rules)) {
    
    rule_lift <- c(
      rule_lift,
      rules[[i]]$lift
    )
  }
  
  
  barplot(
    rule_lift,
    names.arg = rule_names,
    col = "orange",
    main = "Lift of Association Rules",
    xlab = "Association Rules",
    ylab = "Lift",
    las = 2
  )
  
  abline(
    h = 1,
    col = "red",
    lty = 2,
    lwd = 2
  )
  
  legend(
    "topright",
    legend = "Lift = 1",
    col = "red",
    lty = 2,
    lwd = 2
  )
}
