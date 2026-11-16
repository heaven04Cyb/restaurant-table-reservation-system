<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tablebook.model.User" %>
<%@ page import="com.tablebook.model.Restaurant" %>
<%@ page import="java.util.ArrayList" %>
<%
    ArrayList<User> users = (ArrayList<User>) request.getAttribute("users");
    ArrayList<Restaurant> restaurants = (ArrayList<Restaurant>) request.getAttribute("restaurants");
    Integer totalRes = (Integer) request.getAttribute("totalReservations");
    if (totalRes == null) totalRes = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - TableBook</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = { theme: { extend: { colors: { orange: { 500: '#f97316' } }, fontFamily: { sans: ['Inter', 'sans-serif'] } } } }
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://unpkg.com/feather-icons"></script>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #020617; }
        .glass { background: rgba(15, 23, 42, 0.7); backdrop-filter: blur(16px); border: 1px solid rgba(255, 255, 255, 0.05); }
        .glass-card { background: linear-gradient(145deg, rgba(30, 41, 59, 0.4) 0%, rgba(15, 23, 42, 0.6) 100%); backdrop-filter: blur(12px); border: 1px solid rgba(255, 255, 255, 0.08); }
        .toast-enter { animation: toast-in 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        @keyframes toast-in { 0% { transform: translateY(-100%); opacity: 0; } 100% { transform: translateY(0); opacity: 1; } }
    </style>
</head>
<body class="text-slate-200 min-h-screen pb-20 relative overflow-x-hidden">
    <!-- Background Accents -->
    <div class="absolute top-0 left-1/4 w-96 h-96 bg-orange-500/10 rounded-full blur-[100px] pointer-events-none"></div>
    <div class="absolute bottom-0 right-1/4 w-[30rem] h-[30rem] bg-slate-500/10 rounded-full blur-[100px] pointer-events-none"></div>

    <!-- Toast Alerts -->
    <div class="fixed top-6 left-1/2 transform -translate-x-1/2 z-[100] w-full max-w-md px-4 pointer-events-none">
        <% if (request.getParameter("error") != null) { %>
            <div class="toast-enter pointer-events-auto flex items-center gap-3 bg-red-950/80 backdrop-blur-md border border-red-500/50 text-red-200 p-4 rounded-2xl shadow-xl">
                <i data-feather="alert-circle" class="text-red-500 w-5 h-5"></i>
                <p class="font-medium text-sm"><%= request.getParameter("error") %></p>
            </div>
        <% } %>
        <% if (request.getParameter("success") != null) { %>
            <div class="toast-enter pointer-events-auto flex items-center gap-3 bg-green-950/80 backdrop-blur-md border border-green-500/50 text-green-200 p-4 rounded-2xl shadow-xl">
                <i data-feather="check-circle" class="text-green-500 w-5 h-5"></i>
                <p class="font-medium text-sm"><%= request.getParameter("success") %></p>
            </div>
        <% } %>
    </div>

    <!-- Navbar -->
    <nav class="glass sticky top-0 z-50 shadow-lg">
        <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
            <div class="flex items-center gap-3">
                <div class="bg-orange-500 p-2 rounded-lg">
                    <i data-feather="shield" class="text-white w-5 h-5"></i>
                </div>
                <h1 class="text-2xl font-bold tracking-tight">Table<span class="text-orange-500">Book</span> <span class="font-light text-slate-400 text-lg ml-1">Admin</span></h1>
            </div>
            <div class="flex items-center gap-6">
                <a href="${pageContext.request.contextPath}/auth/logout" class="flex items-center gap-2 text-slate-300 hover:text-orange-500 transition-colors font-medium">
                    <i data-feather="log-out" class="w-4 h-4"></i>
                    <span class="hidden sm:inline">Logout</span>
                </a>
            </div>
        </div>
    </nav>

    <div class="max-w-7xl mx-auto px-6 py-10 relative z-10">
        
        <!-- Metrics Hero Section -->
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-6 mb-12">
            <div class="glass-card p-6 rounded-3xl relative overflow-hidden group">
                <div class="absolute -right-6 -top-6 bg-orange-500/10 w-24 h-24 rounded-full blur-xl group-hover:bg-orange-500/20 transition-colors"></div>
                <div class="flex items-center gap-4 mb-4">
                    <div class="bg-slate-800/80 p-3 rounded-xl border border-slate-700/50"><i data-feather="users" class="text-orange-400"></i></div>
                    <p class="text-slate-400 text-sm font-semibold uppercase tracking-wider">Total Users</p>
                </div>
                <h2 class="text-4xl font-bold text-white"><%= (users != null) ? users.size() : 0 %></h2>
            </div>
            <div class="glass-card p-6 rounded-3xl relative overflow-hidden group">
                <div class="absolute -right-6 -top-6 bg-orange-500/10 w-24 h-24 rounded-full blur-xl group-hover:bg-orange-500/20 transition-colors"></div>
                <div class="flex items-center gap-4 mb-4">
                    <div class="bg-slate-800/80 p-3 rounded-xl border border-slate-700/50"><i data-feather="home" class="text-orange-400"></i></div>
                    <p class="text-slate-400 text-sm font-semibold uppercase tracking-wider">Restaurants</p>
                </div>
                <h2 class="text-4xl font-bold text-white"><%= (restaurants != null) ? restaurants.size() : 0 %></h2>
            </div>
            <div class="glass-card p-6 rounded-3xl relative overflow-hidden group">
                <div class="absolute -right-6 -top-6 bg-orange-500/10 w-24 h-24 rounded-full blur-xl group-hover:bg-orange-500/20 transition-colors"></div>
                <div class="flex items-center gap-4 mb-4">
                    <div class="bg-slate-800/80 p-3 rounded-xl border border-slate-700/50"><i data-feather="calendar" class="text-orange-400"></i></div>
                    <p class="text-slate-400 text-sm font-semibold uppercase tracking-wider">Reservations</p>
                </div>
                <h2 class="text-4xl font-bold text-white"><%= totalRes %></h2>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
            
            <!-- Left Column: Add Owner & Manage Users -->
            <div class="lg:col-span-5 space-y-8">
                
                <!-- Add Owner Form -->
                <div class="glass-card p-8 rounded-3xl shadow-xl">
                    <h3 class="text-xl font-bold mb-6 flex items-center gap-2 pb-4 border-b border-slate-700/50">
                        <i data-feather="user-plus" class="text-orange-500"></i> Provision Owner
                    </h3>
                    <form action="${pageContext.request.contextPath}/admin/dashboard" method="post" class="space-y-5">
                        <input type="hidden" name="action" value="createOwner">
                        <div>
                            <label class="block text-slate-400 text-sm font-medium mb-1.5">Owner Full Name</label>
                            <div class="relative">
                                <i data-feather="user" class="absolute left-3 top-1/2 transform -translate-y-1/2 text-slate-500 w-4 h-4"></i>
                                <input type="text" name="name" placeholder="John Doe" class="w-full bg-slate-900/50 border border-slate-700 rounded-xl pl-10 pr-4 py-3 focus:outline-none focus:border-orange-500 text-white" required>
                            </div>
                        </div>
                        <div>
                            <label class="block text-slate-400 text-sm font-medium mb-1.5">Email Address</label>
                            <div class="relative">
                                <i data-feather="mail" class="absolute left-3 top-1/2 transform -translate-y-1/2 text-slate-500 w-4 h-4"></i>
                                <input type="email" name="email" placeholder="owner@restaurant.com" class="w-full bg-slate-900/50 border border-slate-700 rounded-xl pl-10 pr-4 py-3 focus:outline-none focus:border-orange-500 text-white" required>
                            </div>
                        </div>
                        <div>
                            <label class="block text-slate-400 text-sm font-medium mb-1.5">Temporary Password</label>
                            <div class="relative">
                                <i data-feather="lock" class="absolute left-3 top-1/2 transform -translate-y-1/2 text-slate-500 w-4 h-4"></i>
                                <input type="password" name="password" placeholder="••••••••" class="w-full bg-slate-900/50 border border-slate-700 rounded-xl pl-10 pr-4 py-3 focus:outline-none focus:border-orange-500 text-white" required>
                            </div>
                        </div>
                        <button type="submit" class="w-full bg-slate-800 hover:bg-orange-500 border border-slate-700 hover:border-orange-500 text-white font-bold py-3.5 rounded-xl transition-all shadow-lg mt-2 flex justify-center items-center gap-2">
                            <i data-feather="check" class="w-4 h-4"></i> Create Account
                        </button>
                    </form>
                </div>

                <!-- Users List -->
                <div class="glass-card p-8 rounded-3xl shadow-xl flex flex-col h-[500px]">
                    <h3 class="text-xl font-bold mb-6 flex items-center gap-2 pb-4 border-b border-slate-700/50 shrink-0">
                        <i data-feather="users" class="text-orange-500"></i> System Users
                    </h3>
                    <div class="space-y-3 overflow-y-auto pr-2 custom-scrollbar flex-1">
                        <% if (users != null && !users.isEmpty()) { 
                            for (User u : users) { 
                                String roleBadge = "bg-blue-500/10 text-blue-400 border-blue-500/20";
                                if(u.getRole().equals("ADMIN")) roleBadge = "bg-red-500/10 text-red-400 border-red-500/20";
                                if(u.getRole().equals("OWNER")) roleBadge = "bg-orange-500/10 text-orange-400 border-orange-500/20";
                        %>
                            <div class="bg-slate-900/60 p-4 rounded-2xl flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 border border-slate-700/50 hover:border-slate-600 transition-colors">
                                <div class="flex items-center gap-3">
                                    <div class="w-10 h-10 rounded-full bg-slate-800 flex items-center justify-center text-slate-400 font-bold border border-slate-700">
                                        <%= u.getName().substring(0, 1).toUpperCase() %>
                                    </div>
                                    <div>
                                        <p class="font-bold text-slate-200 text-sm"><%= u.getName() %></p>
                                        <p class="text-xs text-slate-400"><%= u.getEmail() %></p>
                                    </div>
                                </div>
                                <div class="flex items-center gap-3 w-full sm:w-auto justify-between sm:justify-end">
                                    <span class="px-2.5 py-1 rounded-md text-[10px] font-bold uppercase tracking-wider border <%= roleBadge %>">
                                        <%= u.getRole() %>
                                    </span>
                                    <% if (!u.getRole().equals("ADMIN")) { %>
                                        <form action="${pageContext.request.contextPath}/admin/dashboard" method="post">
                                            <input type="hidden" name="action" value="deleteUser">
                                            <input type="hidden" name="userId" value="<%= u.getId() %>">
                                            <button type="submit" class="text-red-400 hover:text-white bg-red-500/10 hover:bg-red-500 p-2 rounded-lg border border-red-500/20 hover:border-red-500 transition-all" title="Delete User">
                                                <i data-feather="trash-2" class="w-3.5 h-3.5"></i>
                                            </button>
                                        </form>
                                    <% } else { %>
                                        <div class="w-8"></div> <!-- Spacer for alignment -->
                                    <% } %>
                                </div>
                            </div>
                        <% } } %>
                    </div>
                </div>

            </div>

            <!-- Right Column: Restaurants -->
            <div class="lg:col-span-7">
                <div class="glass-card p-8 rounded-3xl shadow-xl h-full flex flex-col">
                    <div class="flex items-center justify-between mb-6 pb-4 border-b border-slate-700/50 shrink-0">
                        <h3 class="text-xl font-bold flex items-center gap-2">
                            <i data-feather="briefcase" class="text-orange-500"></i> Registered Restaurants
                        </h3>
                    </div>
                    
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-5 overflow-y-auto pr-2 custom-scrollbar flex-1 pb-4">
                        <% if (restaurants != null && !restaurants.isEmpty()) { 
                            int imgIndex = 1;
                            for (Restaurant r : restaurants) { 
                                String imgUrl = "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?q=80&w=400&auto=format&fit=crop";
                                if(imgIndex % 2 == 0) imgUrl = "https://images.unsplash.com/photo-1550966871-3ed3cdb5ed0c?q=80&w=400&auto=format&fit=crop";
                                if(imgIndex % 3 == 0) imgUrl = "https://images.unsplash.com/photo-1559339352-11d035aa65de?q=80&w=400&auto=format&fit=crop";
                                imgIndex++;
                        %>
                            <div class="bg-slate-900/80 rounded-2xl border border-slate-700 overflow-hidden flex flex-col group hover:border-slate-500 transition-colors">
                                <div class="h-24 overflow-hidden relative">
                                    <div class="absolute inset-0 bg-slate-900/50 z-10"></div>
                                    <img src="<%= imgUrl %>" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500">
                                </div>
                                <div class="p-5 flex-1 flex flex-col">
                                    <h4 class="font-bold text-white text-lg mb-1"><%= r.getName() %></h4>
                                    <p class="text-xs text-slate-400 flex items-center gap-1.5 mb-1.5"><i data-feather="map-pin" class="w-3 h-3 text-orange-500"></i> <%= r.getLocation() %></p>
                                    <p class="text-xs text-slate-400 flex items-center gap-1.5 mb-4"><i data-feather="clock" class="w-3 h-3 text-orange-500"></i> <%= r.getOperatingHours() %></p>
                                    
                                    <div class="mt-auto border-t border-slate-800 pt-4 flex justify-between items-center">
                                        <span class="text-[10px] uppercase font-bold text-green-400 bg-green-500/10 border border-green-500/20 px-2 py-1 rounded">Active</span>
                                        <form action="${pageContext.request.contextPath}/admin/dashboard" method="post">
                                            <input type="hidden" name="action" value="deleteRestaurant">
                                            <input type="hidden" name="restaurantId" value="<%= r.getId() %>">
                                            <button type="submit" class="text-xs text-red-400 hover:text-white bg-slate-800 hover:bg-red-500 px-3 py-1.5 rounded-lg border border-slate-700 hover:border-red-500 transition-all font-medium flex items-center gap-1" onclick="return confirm('Delete this restaurant from the platform?');">
                                                <i data-feather="trash" class="w-3 h-3"></i> Revoke
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        <% } } else { %>
                            <div class="col-span-full h-full flex flex-col items-center justify-center py-20 opacity-50">
                                <i data-feather="slash" class="w-12 h-12 text-slate-500 mb-4"></i>
                                <p class="text-slate-400 font-medium">No active restaurants found.</p>
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
