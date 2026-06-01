import React, { useState, useEffect } from 'react';
import './App.css';

// Set your C# ASP.NET Web API base URL here
const API_BASE_URL = 'http://localhost:5167/api/products'; 

function App() {
  // 1. React Component Hooks & State Management
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Form states for Create / Update operations
  const [formData, setFormData] = useState({ productName: '', categoryID: '', subCategoryID: '', unitPrice: '' });
  const [editingProductId, setEditingProductId] = useState(null);

  // 2. READ: Fetch all products on component initialization
  const fetchProducts = async () => {
    try {
      setLoading(true);
      const response = await fetch(API_BASE_URL);
      if (!response.ok) throw new Error('Failed to retrieve products from backend api');
      const data = await response.json();
      setProducts(data);
      setError(null);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchProducts();
  }, []);

  // Handle Form field tracking changes
  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  // 3. CREATE & UPDATE: Submit product data mapping
  const handleSubmit = async (e) => {
    e.preventDefault();
    
    const productPayload = {
      productName: formData.productName,
      categoryID: parseInt(formData.categoryID),
      subCategoryID: parseInt(formData.subCategoryID),
      unitPrice: parseFloat(formData.unitPrice)
    };

    try {
      if (editingProductId) {
        // PUT /api/products/{id}
        const response = await fetch(`${API_BASE_URL}/${editingProductId}`, {
          method: 'PUT',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ productID: editingProductId, ...productPayload })
        });
        if (!response.ok) throw new Error('Failed to update product details');
      } else {
        // POST /api/products
        const response = await fetch(API_BASE_URL, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(productPayload)
        });
        if (!response.ok) throw new Error('Failed to register new product entry');
      }

      // Reset application state upon success
      setFormData({ productName: '', categoryID: '', subCategoryID: '', unitPrice: '' });
      setEditingProductId(null);
      fetchProducts(); // Refresh list display grid
    } catch (err) {
      alert(err.message);
    }
  };

  // Populate data inputs for updating an existing entry
  const startEdit = (product) => {
    setEditingProductId(product.productID);
    setFormData({
      productName: product.productName,
      categoryID: product.categoryID,
      subCategoryID: product.subCategoryID,
      unitPrice: product.unitPrice
    });
  };

  // 4. DELETE: Drop a product by ID sequence
  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to remove this product record?')) return;

    try {
      // DELETE /api/products/{id}
      const response = await fetch(`${API_BASE_URL}/${id}`, { method: 'DELETE' });
      if (!response.ok) throw new Error('Failed to delete target product row');
      fetchProducts(); // Refresh list grid
    } catch (err) {
      alert(err.message);
    }
  };

  // Cancel active edit operational flow
  const cancelEdit = () => {
    setEditingProductId(null);
    setFormData({ productName: '', categoryID: '', subCategoryID: '', unitPrice: '' });
  };

  return (
    <div className="container" style={{ padding: '20px', fontFamily: 'Arial, sans-serif' }}>
      <h2>📦 Superstore Product Inventory Dashboard</h2>
      <hr />

      {/* Product Management CRUD Form Panel */}
      <div style={{ background: '#f4f4f4', padding: '15px', borderRadius: '5px', marginBottom: '20px' }}>
        <h3>{editingProductId ? '✏️ Edit Product Details' : '➕ Add New Catalog Product'}</h3>
        <form onSubmit={handleSubmit} style={{ display: 'flex', gap: '10px', flexWrap: 'wrap' }}>
          <input type="text" name="productName" placeholder="Product Title Name" value={formData.productName} onChange={handleInputChange} required style={{ padding: '8px', minWidth: '200px' }} />
          <input type="number" name="categoryID" placeholder="Category Integer ID" value={formData.categoryID} onChange={handleInputChange} required style={{ padding: '8px' }} />
          <input type="number" name="subCategoryID" placeholder="SubCategory Integer ID" value={formData.subCategoryID} onChange={handleInputChange} required style={{ padding: '8px' }} />
          <input type="number" step="0.01" name="unitPrice" placeholder="Unit Purchase Price" value={formData.unitPrice} onChange={handleInputChange} required style={{ padding: '8px' }} />
          
          <button type="submit" style={{ padding: '8px 15px', background: '#28a745', color: '#fff', border: 'none', borderRadius: '3px', cursor: 'pointer' }}>
            {editingProductId ? 'Save Changes' : 'Publish Product'}
          </button>
          {editingProductId && (
            <button type="button" onClick={cancelEdit} style={{ padding: '8px 15px', background: '#6c757d', color: '#fff', border: 'none', borderRadius: '3px', cursor: 'pointer' }}>
              Cancel
            </button>
          )}
        </form>
      </div>

      {/* Conditional Interface Status States Handling */}
      {loading && <p>⌛ Connecting to C# Web API Layer...</p>}
      {error && <p style={{ color: 'red' }}>⚠️ Error: {error}</p>}

      {/* Main Tabular Product Listing Grid View */}
      {!loading && !error && (
        <table border="1" cellPadding="8" style={{ width: '100%', borderCollapse: 'collapse', marginTop: '10px' }}>
          <thead>
            <tr style={{ background: '#e2e2e2' }}>
              <th>Product ID</th>
              <th>Name Specification</th>
              <th>Category ID</th>
              <th>Sub-Category ID</th>
              <th>Unit Retail Price</th>
              <th>Control Actions</th>
            </tr>
          </thead>
          <tbody>
            {products.length === 0 ? (
              <tr><td colSpan="6" style={{ textAlign: 'center' }}>No available active inventory records found.</td></tr>
            ) : (
              products.map((product) => (
                <tr key={product.productID}>
                  <td>{product.productID}</td>
                  <td><strong>{product.productName}</strong></td>
                  <td>{product.categoryID}</td>
                  <td>{product.subCategoryID}</td>
                  <td>${parseFloat(product.unitPrice).toFixed(2)}</td>
                  <td>
                    <button onClick={() => startEdit(product)} style={{ marginRight: '8px', padding: '4px 10px', background: '#007bff', color: '#fff', border: 'none', borderRadius: '3px', cursor: 'pointer' }}>Edit</button>
                    <button onClick={() => handleDelete(product.productID)} style={{ padding: '4px 10px', background: '#dc3545', color: '#fff', border: 'none', borderRadius: '3px', cursor: 'pointer' }}>Delete</button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      )}
    </div>
  );
}

export default App;
