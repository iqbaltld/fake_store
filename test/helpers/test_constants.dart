import 'package:fake_store/features/authentication/domain/entities/user.dart';
import 'package:fake_store/features/cart/domain/entities/cart_item.dart';
import 'package:fake_store/features/product/domain/entities/product.dart';

// Test Rating
const testRating1 = Rating(rate: 3.9, count: 120);
const testRating2 = Rating(rate: 4.1, count: 259);

// Test Products
const testProduct = Product(
  id: 1,
  title: 'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops',
  price: 109.95,
  description: 'Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday',
  category: "men's clothing",
  image: 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
  rating: testRating1,
);

const testProduct2 = Product(
  id: 2,
  title: 'Mens Casual Premium Slim Fit T-Shirts',
  price: 22.3,
  description: 'Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing.',
  category: "men's clothing",
  image: 'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg',
  rating: testRating2,
);

const testProducts = [testProduct, testProduct2];

// Test Categories
const testCategories = ['electronics', 'jewelery', "men's clothing", "women's clothing"];
const testCategory = "men's clothing";

// Test User
const testUser = User(
  id: 1,
  email: 'john@gmail.com',
  username: 'johnd',
  firstName: 'John',
  lastName: 'Doe',
  phone: '1-570-236-7033',
);

// Test Cart Items
const testCartItem = CartItem(
  product: testProduct,
  quantity: 2,
);

const testCartItem2 = CartItem(
  product: testProduct2,
  quantity: 1,
);

const testCartItems = [testCartItem, testCartItem2];

// Test Constants
const testProductId = 1;
const testQuantity = 2;
const testCartTotal = 242.2; // (109.95 * 2) + (22.3 * 1)