// ==========================================
// 1. CREATING COLLECTIONS & INSERTING DATA
// ==========================================

// Insert Users
db.users.insertMany([
    {
      _id: 1,
      username: "AdminUser",
      email: "admin@companyx.com",
      role: "Admin"
    },
    {
      _id: 2,
      username: "JohnSmith",
      email: "john@companyx.com",
      role: "User"
    }
  ]);
  
  // Insert Categories
  db.categories.insertMany([
    { _id: 101, name: "Electronics", description: "Gadgets" },
    { _id: 102, name: "Office Supplies", description: "Stationery" }
  ]);
  
  // Insert Items (Referencing Category ID)
  db.items.insertMany([
    {
      _id: 201,
      name: "Wireless Mouse",
      price: 25.00,
      size: "Small",
      stock: 100,
      categoryId: 101
    },
    {
      _id: 202,
      name: "Ergonomic Chair",
      price: 150.00,
      size: "Large",
      stock: 20,
      categoryId: 102
    }
  ]);
  
  // Insert Orders (Referencing User and Items)
  db.orders.insertOne({
    _id: 301,
    userId: 2,
    status: "Pending",
    orderDate: new Date(),
    items: [
      { itemId: 201, quantity: 2 },
      { itemId: 202, quantity: 1 }
    ]
  });
  
  
  // ==========================================
  // 2. UPDATING RECORDS
  // ==========================================
  
  // Update the status of an order
  db.orders.updateOne(
    { _id: 301 },
    { $set: { status: "Approved" } }
  );
  
  // Update the stock of a specific item
  db.items.updateOne(
    { _id: 201 },
    { $inc: { stock: -2 } }
  );
  
  
  // ==========================================
  // 3. DELETING RECORDS
  // ==========================================
  
  // Delete a specific order
  db.orders.deleteOne({ _id: 301 });
  
  // Delete a specific item
  db.items.deleteOne({ _id: 202 });
  
  
  // ==========================================
  // 4. QUERY WITH LOOKUP (Join equivalent)
  // ==========================================
  
  // Find items and populate their Category details
  db.items.aggregate([
    {
      $lookup: {
        from: "categories",       // The collection to join
        localField: "categoryId", // Field from the items collection
        foreignField: "_id",      // Field from the categories collection
        as: "categoryDetails"     // Output array field
      }
    }
  ]);
  
  // Find Orders and populate User details
  db.orders.aggregate([
    {
      $lookup: {
        from: "users",
        localField: "userId",
        foreignField: "_id",
        as: "userDetails"
      }
    }
  ]);