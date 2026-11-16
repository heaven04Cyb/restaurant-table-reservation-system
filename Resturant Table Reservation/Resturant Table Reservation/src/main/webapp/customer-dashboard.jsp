<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tablebook.model.Restaurant" %>
<%@ page import="com.tablebook.model.Table" %>
<%@ page import="com.tablebook.model.Reservation" %>
<%@ page import="java.util.ArrayList" %>
<%
    ArrayList<Restaurant> restaurants = (ArrayList<Restaurant>) request.getAttribute("restaurants");
    ArrayList<Table> tables = (ArrayList<Table>) request.getAttribute("tables");
    ArrayList<Reservation> myReservations = (ArrayList<Reservation>) request.getAttribute("myReservations");
    String selectedRestaurantId = (String) request.getAttribute("selectedRestaurantId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard - TableBook</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = { theme: { extend: { colors: { orange: { 500: '#f97316' } }, fontFamily: { sans: ['Inter', 'sans-serif'] } } } }
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://unpkg.com/feather-icons"></script>
    <style>
        body { font-family: 'Inter', sans-serif; background-image: radial-gradient(circle at top right, rgba(30, 41, 59, 1), rgba(2, 6, 23, 1)); }
        .glass { background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(16px); border: 1px solid rgba(255, 255, 255, 0.05); }
        .glass-card { background: linear-gradient(145deg, rgba(30, 41, 59, 0.4) 0%, rgba(15, 23, 42, 0.4) 100%); backdrop-filter: blur(12px); border: 1px solid rgba(255, 255, 255, 0.08); }
        .toast-enter { animation: toast-in 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        @keyframes toast-in { 0% { transform: translateY(-100%); opacity: 0; } 100% { transform: translateY(0); opacity: 1; } }
        /* Rating Component CSS */
        .star-rating { display: flex; flex-direction: row-reverse; justify-content: center; gap: 0.25rem; }
        .star-rating input { display: none; }
        .star-rating label { color: #334155; cursor: pointer; transition: color 0.2s; }
        .star-rating label:hover, .star-rating label:hover ~ label, .star-rating input:checked ~ label { color: #f97316; }
    </style>
</head>
<body class="text-slate-200 min-h-screen">
    
    <!-- Toast Alerts -->
    <div class="fixed top-6 left-1/2 transform -translate-x-1/2 z-[100] w-full max-w-md px-4 pointer-events-none">
        <% if (request.getParameter("error") != null) { %>
            <div class="toast-enter pointer-events-auto flex items-center gap-3 bg-red-950/80 backdrop-blur-md border border-red-500/50 text-red-200 p-4 rounded-2xl shadow-xl">
                <i data-feather="alert-circle" class="text-red-500"></i>
                <p class="font-medium text-sm"><%= request.getParameter("error") %></p>
            </div>
        <% } %>
        <% if (request.getParameter("success") != null) { %>
            <div class="toast-enter pointer-events-auto flex items-center gap-3 bg-green-950/80 backdrop-blur-md border border-green-500/50 text-green-200 p-4 rounded-2xl shadow-xl">
                <i data-feather="check-circle" class="text-green-500"></i>
                <p class="font-medium text-sm"><%= request.getParameter("success") %></p>
            </div>
        <% } %>
    </div>

    <!-- Navbar -->
    <nav class="glass sticky top-0 z-50 shadow-lg">
        <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
            <div class="flex items-center gap-3">
                <div class="bg-orange-500 p-2 rounded-lg">
                    <i data-feather="compass" class="text-white w-5 h-5"></i>
                </div>
                <h1 class="text-2xl font-bold tracking-tight">Table<span class="text-orange-500">Book</span></h1>
            </div>
            <div class="flex items-center gap-6">
                <div class="hidden md:flex items-center gap-2 text-slate-400">
                    <i data-feather="user" class="w-4 h-4"></i>
                    <span class="text-sm font-medium"><%= session.getAttribute("userEmail") %></span>
                </div>
                <a href="${pageContext.request.contextPath}/auth/logout" class="flex items-center gap-2 text-slate-300 hover:text-orange-500 transition-colors font-medium">
                    <i data-feather="log-out" class="w-4 h-4"></i>
                    <span class="hidden sm:inline">Logout</span>
                </a>
            </div>
        </div>
    </nav>

    <div class="max-w-7xl mx-auto px-6 py-10 space-y-12">
        
        <!-- Header Section with Profile Update -->
        <div class="flex flex-col lg:flex-row gap-8 items-stretch">
            <div class="flex-1 glass-card p-8 rounded-3xl shadow-xl relative overflow-hidden group">
                <div class="absolute -right-10 -top-10 bg-orange-500/10 w-40 h-40 rounded-full blur-3xl group-hover:bg-orange-500/20 transition-all duration-700"></div>
                <h2 class="text-3xl font-bold mb-2">Welcome Back!</h2>
                <p class="text-slate-400 mb-6">Ready for your next culinary adventure?</p>
                <form action="${pageContext.request.contextPath}/auth/profile" method="post" class="flex items-center gap-2">
                    <input type="hidden" name="action" value="delete">
                    <button type="submit" class="flex items-center gap-2 text-red-400 hover:text-red-300 text-sm font-medium transition-colors bg-red-500/10 px-4 py-2 rounded-lg border border-red-500/20 hover:bg-red-500/20" onclick="return confirm('Delete your account forever?');">
                        <i data-feather="trash-2" class="w-4 h-4"></i> Delete Account
                    </button>
                </form>
            </div>

            <div class="flex-1 glass-card p-8 rounded-3xl shadow-xl">
                <div class="flex items-center gap-3 mb-6">
                    <i data-feather="settings" class="text-slate-400"></i>
                    <h3 class="text-xl font-bold">Update Profile</h3>
                </div>
                <form action="${pageContext.request.contextPath}/auth/profile" method="post" class="flex flex-col sm:flex-row gap-4">
                    <input type="hidden" name="action" value="update">
                    <div class="flex-1 relative">
                        <i data-feather="user" class="absolute left-3 top-1/2 transform -translate-y-1/2 text-slate-500 w-4 h-4"></i>
                        <input type="text" name="name" placeholder="New Name" class="w-full bg-slate-900/50 border border-slate-700 rounded-xl pl-10 pr-4 py-2.5 focus:border-orange-500 focus:ring-1 focus:ring-orange-500 text-white text-sm" required>
                    </div>
                    <div class="flex-1 relative">
                        <i data-feather="lock" class="absolute left-3 top-1/2 transform -translate-y-1/2 text-slate-500 w-4 h-4"></i>
                        <input type="password" name="password" placeholder="New Password" class="w-full bg-slate-900/50 border border-slate-700 rounded-xl pl-10 pr-4 py-2.5 focus:border-orange-500 focus:ring-1 focus:ring-orange-500 text-white text-sm" required>
                    </div>
                    <button type="submit" class="bg-orange-500 hover:bg-orange-600 text-white font-bold px-6 py-2.5 rounded-xl transition-all shadow-lg hover:shadow-orange-500/25 flex items-center justify-center">
                        Save
                    </button>
                </form>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
            <!-- Left Column: Find a Restaurant / Booking Form -->
            <div class="lg:col-span-7 space-y-8">
                
                <% if (selectedRestaurantId == null || selectedRestaurantId.isEmpty()) { %>
                    <!-- Discover Restaurants Grid -->
                    <div class="flex items-center justify-between mb-6">
                        <h3 class="text-2xl font-bold flex items-center gap-3">
                            <i data-feather="map-pin" class="text-orange-500"></i> Find a Restaurant
                        </h3>
                    </div>
                    
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                        <% if (restaurants != null && !restaurants.isEmpty()) { 
                            int imgIndex = 1;
                            for (Restaurant r : restaurants) { 
                                String imgUrl = "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=600&auto=format&fit=crop";
                                if(imgIndex % 2 == 0) imgUrl = "https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?q=80&w=600&auto=format&fit=crop";
                                if(imgIndex % 3 == 0) imgUrl = "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=600&auto=format&fit=crop";
                                imgIndex++;
                        %>
                            <div class="glass-card rounded-2xl overflow-hidden group hover:-translate-y-1 transition-all duration-300 hover:shadow-2xl hover:shadow-orange-500/10 border border-slate-700/50 flex flex-col">
                                <div class="h-40 relative overflow-hidden">
                                    <div class="absolute inset-0 bg-slate-900/40 group-hover:bg-transparent transition-colors z-10"></div>
                                    <img src="<%= imgUrl %>" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700">
                                </div>
                                <div class="p-5 flex-1 flex flex-col justify-between">
                                    <div>
                                        <h4 class="text-lg font-bold text-white mb-1"><%= r.getName() %></h4>
                                        <p class="text-slate-400 text-xs flex items-center gap-1 mb-2"><i data-feather="map-pin" class="w-3 h-3"></i> <%= r.getLocation() %></p>
                                        <p class="text-slate-500 text-xs flex items-center gap-1 mb-4"><i data-feather="clock" class="w-3 h-3"></i> <%= r.getOperatingHours() %></p>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/customer/dashboard" method="get">
                                        <input type="hidden" name="restaurantId" value="<%= r.getId() %>">
                                        <button type="submit" class="w-full bg-slate-800 hover:bg-orange-500 text-slate-300 hover:text-white font-medium py-2.5 rounded-xl border border-slate-700 hover:border-orange-500 transition-all flex items-center justify-center gap-2 text-sm">
                                            View Tables <i data-feather="arrow-right" class="w-4 h-4"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        <% } } else { %>
                            <div class="col-span-full glass-card p-10 text-center rounded-2xl">
                                <i data-feather="frown" class="w-12 h-12 text-slate-600 mx-auto mb-3"></i>
                                <p class="text-slate-400">No restaurants available at the moment.</p>
                            </div>
                        <% } %>
                    </div>
                <% } else { %>
                    <!-- Booking Form for Selected Restaurant -->
                    <div class="glass-card p-8 rounded-3xl shadow-xl">
                        <div class="flex items-center justify-between mb-8 border-b border-slate-700/50 pb-6">
                            <h3 class="text-2xl font-bold flex items-center gap-3">
                                <i data-feather="calendar" class="text-orange-500"></i> Reserve a Table
                            </h3>
                            <a href="${pageContext.request.contextPath}/customer/dashboard" class="text-slate-400 hover:text-orange-500 flex items-center gap-1 text-sm font-medium transition-colors">
                                <i data-feather="arrow-left" class="w-4 h-4"></i> Back
                            </a>
                        </div>

                        <form action="${pageContext.request.contextPath}/customer/book" method="post" class="space-y-6">
                            <input type="hidden" name="restaurantId" value="<%= selectedRestaurantId %>">
                            
                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                                <div>
                                    <label class="block text-slate-400 text-sm font-medium mb-2">Select Table</label>
                                    <div class="relative">
                                        <i data-feather="layers" class="absolute left-4 top-1/2 transform -translate-y-1/2 text-slate-500 w-4 h-4 pointer-events-none"></i>
                                        <select name="tableId" class="w-full bg-slate-900/50 border border-slate-700 rounded-xl pl-11 pr-4 py-3.5 focus:border-orange-500 focus:ring-1 focus:ring-orange-500 text-white appearance-none" required>
                                            <option value="" disabled selected>Choose table...</option>
                                            <% if (tables != null && !tables.isEmpty()) { 
                                                for (Table t : tables) { %>
                                                    <option value="<%= t.getId() %>">Table <%= t.getTableNumber() %> (Seats: <%= t.getCapacity() %>)</option>
                                            <% } } %>
                                        </select>
                                        <i data-feather="chevron-down" class="absolute right-4 top-1/2 transform -translate-y-1/2 text-slate-500 w-4 h-4 pointer-events-none"></i>
                                    </div>
                                </div>
                                <div>
                                    <label class="block text-slate-400 text-sm font-medium mb-2">Party Size</label>
                                    <div class="relative">
                                        <i data-feather="users" class="absolute left-4 top-1/2 transform -translate-y-1/2 text-slate-500 w-4 h-4"></i>
                                        <input type="number" name="partySize" min="1" placeholder="Number of guests" class="w-full bg-slate-900/50 border border-slate-700 rounded-xl pl-11 pr-4 py-3.5 focus:border-orange-500 focus:ring-1 focus:ring-orange-500 text-white" required>
                                    </div>
                                </div>
                            </div>

                            <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                                <div>
                                    <label class="block text-slate-400 text-sm font-medium mb-2">Date</label>
                                    <div class="relative">
                                        <input type="date" name="date" class="w-full bg-slate-900/50 border border-slate-700 rounded-xl px-4 py-3.5 focus:border-orange-500 focus:ring-1 focus:ring-orange-500 text-white" required>
                                    </div>
                                </div>
                                <div>
                                    <label class="block text-slate-400 text-sm font-medium mb-2">Time</label>
                                    <div class="relative">
                                        <input type="time" name="time" class="w-full bg-slate-900/50 border border-slate-700 rounded-xl px-4 py-3.5 focus:border-orange-500 focus:ring-1 focus:ring-orange-500 text-white" required>
                                    </div>
                                </div>
                            </div>

                            <% if (tables == null || tables.isEmpty()) { %>
                                <div class="bg-red-500/10 border border-red-500/20 rounded-xl p-4 flex items-start gap-3">
                                    <i data-feather="info" class="text-red-400 mt-0.5 w-5 h-5 flex-shrink-0"></i>
                                    <div>
                                        <h5 class="text-red-400 font-medium">No Tables Available</h5>
                                        <p class="text-red-400/70 text-sm mt-1">This restaurant currently has no available tables setup by the owner.</p>
                                    </div>
                                </div>
                            <% } else { %>
                                <button type="submit" class="w-full group relative flex justify-center items-center gap-2 bg-orange-500 hover:bg-orange-600 text-white font-bold py-4 rounded-xl transition-all shadow-[0_0_20px_rgba(249,115,22,0.3)] hover:shadow-[0_0_30px_rgba(249,115,22,0.5)] mt-6">
                                    Confirm Reservation <i data-feather="check" class="w-5 h-5"></i>
                                </button>
                            <% } %>
                        </form>
                    </div>
                <% } %>
            </div>

            <!-- Right Column: My Bookings -->
            <div class="lg:col-span-5">
                <div class="glass-card p-8 rounded-3xl shadow-xl h-full flex flex-col">
                    <h3 class="text-2xl font-bold mb-6 flex items-center gap-3 pb-4 border-b border-slate-700/50">
                        <i data-feather="bookmark" class="text-orange-500"></i> My Bookings
                    </h3>
                    
                    <div class="space-y-4 overflow-y-auto pr-2 custom-scrollbar flex-1">
                        <% if (myReservations != null && !myReservations.isEmpty()) { 
                            for (Reservation resv : myReservations) { 
                                boolean isCancelled = "Cancelled".equals(resv.getStatus());
                                String badgeColor = isCancelled ? "bg-red-500/10 text-red-400 border-red-500/20" : "bg-green-500/10 text-green-400 border-green-500/20";
                        %>
                            <div class="bg-slate-900/60 p-5 rounded-2xl border border-slate-700/50 hover:border-slate-600 transition-colors">
                                <div class="flex justify-between items-start mb-3">
                                    <div>
                                        <span class="inline-flex items-center gap-1 px-2.5 py-1 bg-slate-800 text-slate-300 text-[10px] uppercase tracking-wider font-bold rounded-md border border-slate-700 mb-2">
                                            <i data-feather="calendar" class="w-3 h-3"></i> <%= resv.getDate() %> &middot; <%= resv.getTime() %>
                                        </span>
                                        <p class="text-slate-200 font-medium text-sm">Table ID: <%= resv.getTableId() %></p>
                                        <p class="text-slate-400 text-xs mt-1">Party of <%= resv.getPartySize() %></p>
                                    </div>
                                    <span class="text-[10px] uppercase font-bold px-2.5 py-1 rounded-md border <%= badgeColor %>">
                                        <%= resv.getStatus() %>
                                    </span>
                                </div>

                                <!-- Actions -->
                                <div class="flex gap-2 mb-3">
                                    <% if (!isCancelled) { %>
                                        <form action="${pageContext.request.contextPath}/customer/reservation" method="post" class="flex-1">
                                            <input type="hidden" name="action" value="cancel">
                                            <input type="hidden" name="reservationId" value="<%= resv.getId() %>">
                                            <button type="submit" class="w-full text-xs bg-slate-800 text-slate-300 hover:bg-orange-500 hover:text-white hover:border-orange-500 border border-slate-700 px-3 py-2 rounded-lg transition-all font-medium flex items-center justify-center gap-1">
                                                <i data-feather="x" class="w-3 h-3"></i> Cancel
                                            </button>
                                        </form>
                                    <% } %>
                                    <form action="${pageContext.request.contextPath}/customer/reservation" method="post" class="flex-1">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="reservationId" value="<%= resv.getId() %>">
                                        <button type="submit" class="w-full text-xs bg-slate-800 text-red-400 hover:bg-red-500 hover:text-white hover:border-red-500 border border-slate-700 px-3 py-2 rounded-lg transition-all font-medium flex items-center justify-center gap-1" onclick="return confirm('Delete this record?');">
                                            <i data-feather="trash" class="w-3 h-3"></i> Delete
                                        </button>
                                    </form>
                                </div>

                                <!-- Review Form: Visually interactive 5-star rating -->
                                <div class="pt-3 border-t border-slate-700/50 mt-2">
                                    <p class="text-xs text-slate-400 mb-2 font-medium">Leave a Review</p>
                                    <form action="${pageContext.request.contextPath}/customer/manage-review" method="post" class="flex flex-col gap-2">
                                        <input type="hidden" name="restaurantId" value="<%= resv.getRestaurantId() %>">
                                        
                                        <div class="flex justify-between items-center gap-2">
                                            <!-- 5 Star Interactive Rating CSS Component -->
                                            <div class="star-rating bg-slate-950 px-3 py-1.5 rounded-lg border border-slate-700 flex-shrink-0">
                                                <input type="radio" id="star5_<%= resv.getId() %>" name="rating" value="5" /><label for="star5_<%= resv.getId() %>" title="5 stars"><i data-feather="star" class="w-4 h-4 fill-current"></i></label>
                                                <input type="radio" id="star4_<%= resv.getId() %>" name="rating" value="4" /><label for="star4_<%= resv.getId() %>" title="4 stars"><i data-feather="star" class="w-4 h-4 fill-current"></i></label>
                                                <input type="radio" id="star3_<%= resv.getId() %>" name="rating" value="3" checked /><label for="star3_<%= resv.getId() %>" title="3 stars"><i data-feather="star" class="w-4 h-4 fill-current"></i></label>
                                                <input type="radio" id="star2_<%= resv.getId() %>" name="rating" value="2" /><label for="star2_<%= resv.getId() %>" title="2 stars"><i data-feather="star" class="w-4 h-4 fill-current"></i></label>
                                                <input type="radio" id="star1_<%= resv.getId() %>" name="rating" value="1" /><label for="star1_<%= resv.getId() %>" title="1 star"><i data-feather="star" class="w-4 h-4 fill-current"></i></label>
                                            </div>
                                            
                                            <div class="flex gap-1">
                                                <button type="submit" name="action" value="update" class="bg-slate-700 hover:bg-slate-600 text-white px-2.5 py-1.5 rounded-lg text-xs font-bold transition-all" title="Save Review">
                                                    <i data-feather="save" class="w-3 h-3"></i>
                                                </button>
                                                <button type="submit" name="action" value="delete" class="bg-red-500/10 hover:bg-red-500 text-red-400 hover:text-white border border-red-500/20 hover:border-red-500 px-2.5 py-1.5 rounded-lg text-xs font-bold transition-all" title="Delete Review">
                                                    <i data-feather="trash-2" class="w-3 h-3"></i>
                                                </button>
                                            </div>
                                        </div>
                                        <input type="text" name="comment" placeholder="Share your experience..." class="w-full bg-slate-950 border border-slate-700 rounded-lg px-3 py-2 text-xs focus:border-orange-500 focus:ring-1 focus:ring-orange-500 text-white outline-none" required>
                                    </form>
                                </div>
                            </div>
                        <% } } else { %>
                            <div class="h-full flex flex-col items-center justify-center text-center py-12 opacity-50">
                                <i data-feather="book-open" class="w-16 h-16 text-slate-500 mb-4"></i>
                                <p class="text-slate-400 font-medium">No bookings found.</p>
                                <p class="text-slate-500 text-sm mt-1">Your upcoming dining experiences will appear here.</p>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        feather.replace();
    </script>
</body>
</html>
