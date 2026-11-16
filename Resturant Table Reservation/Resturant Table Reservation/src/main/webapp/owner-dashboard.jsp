<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tablebook.model.Restaurant" %>
<%@ page import="com.tablebook.model.Table" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%
    ArrayList<Restaurant> restaurants = (ArrayList<Restaurant>) request.getAttribute("restaurants");
    HashMap<String, ArrayList<Table>> tablesMap = (HashMap<String, ArrayList<Table>>) request.getAttribute("tablesMap");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Owner Dashboard - TableBook</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = { theme: { extend: { colors: { orange: { 500: '#f97316' } }, fontFamily: { sans: ['Inter', 'sans-serif'] } } } }
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://unpkg.com/feather-icons"></script>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #0f172a; }
        .glass { background: rgba(15, 23, 42, 0.7); backdrop-filter: blur(16px); border: 1px solid rgba(255, 255, 255, 0.05); }
        .glass-card { background: linear-gradient(145deg, rgba(30, 41, 59, 0.4) 0%, rgba(15, 23, 42, 0.6) 100%); backdrop-filter: blur(12px); border: 1px solid rgba(255, 255, 255, 0.08); }
        .sidebar { background: linear-gradient(180deg, rgba(15, 23, 42, 0.9) 0%, rgba(2, 6, 23, 0.9) 100%); border-right: 1px solid rgba(255, 255, 255, 0.05); }
        .toast-enter { animation: toast-in 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        @keyframes toast-in { 0% { transform: translateY(-100%); opacity: 0; } 100% { transform: translateY(0); opacity: 1; } }
    </style>
</head>
<body class="text-slate-200 min-h-screen flex">

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

    <!-- Sidebar Layout -->
    <aside class="sidebar w-72 flex-shrink-0 min-h-screen flex flex-col fixed inset-y-0 left-0 z-40">
        <div class="p-8 border-b border-slate-700/50">
            <h1 class="text-3xl font-bold tracking-tight">Table<span class="text-orange-500">Book</span></h1>
            <p class="text-slate-500 text-xs tracking-widest uppercase mt-1 font-bold">Owner Portal</p>
        </div>
        
        <div class="flex-1 p-6 flex flex-col gap-2">
            <div class="px-4 py-3 bg-orange-500/10 text-orange-400 rounded-xl font-medium flex items-center gap-3 border border-orange-500/20">
                <i data-feather="grid" class="w-5 h-5"></i> Dashboard
            </div>
            <a href="${pageContext.request.contextPath}/auth/logout" class="px-4 py-3 text-slate-400 hover:text-white hover:bg-slate-800/50 rounded-xl font-medium flex items-center gap-3 transition-colors mt-auto">
                <i data-feather="log-out" class="w-5 h-5"></i> Logout
            </a>
        </div>

        <div class="p-6 border-t border-slate-700/50 bg-slate-900/50">
            <div class="flex items-center gap-3 mb-4">
                <div class="w-10 h-10 rounded-full bg-orange-500 flex items-center justify-center text-white font-bold">
                    <%= ((String)session.getAttribute("userEmail")).substring(0, 1).toUpperCase() %>
                </div>
                <div class="overflow-hidden">
                    <p class="text-sm font-medium text-white truncate"><%= session.getAttribute("userEmail") %></p>
                    <p class="text-xs text-slate-500">Restaurant Owner</p>
                </div>
            </div>
            
            <form action="${pageContext.request.contextPath}/auth/profile" method="post" class="mt-4 border-t border-slate-700/50 pt-4">
                <p class="text-xs text-slate-400 mb-2 font-medium">Account Management</p>
                <input type="hidden" name="action" value="update">
                <input type="text" name="name" placeholder="New Name" class="w-full bg-slate-800 border border-slate-700 rounded-lg px-3 py-2 text-xs focus:border-orange-500 text-white mb-2" required>
                <input type="password" name="password" placeholder="New Password" class="w-full bg-slate-800 border border-slate-700 rounded-lg px-3 py-2 text-xs focus:border-orange-500 text-white mb-2" required>
                <div class="flex gap-2">
                    <button type="submit" class="flex-1 bg-slate-700 hover:bg-orange-500 text-white text-xs font-bold py-2 rounded-lg transition-colors">Update</button>
                    <button type="button" onclick="if(confirm('Delete account?')) { this.nextElementSibling.submit(); }" class="bg-red-500/10 hover:bg-red-500 text-red-400 hover:text-white border border-red-500/20 px-3 py-2 rounded-lg transition-colors" title="Delete Account">
                        <i data-feather="trash-2" class="w-3 h-3"></i>
                    </button>
                </div>
            </form>
            <form action="${pageContext.request.contextPath}/auth/profile" method="post" class="hidden">
                <input type="hidden" name="action" value="delete">
            </form>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="flex-1 ml-72 p-10 lg:p-14 min-h-screen relative pb-32">
        <div class="absolute inset-0 bg-[url('https://www.transparenttextures.com/patterns/cubes.png')] opacity-5 pointer-events-none mix-blend-overlay"></div>

        <div class="max-w-5xl mx-auto relative z-10 space-y-16">

            <!-- Active Restaurants Dashboard Sections -->
            <% if (restaurants != null && !restaurants.isEmpty()) { 
                for (Restaurant restaurant : restaurants) { 
                    ArrayList<Table> tables = tablesMap.get(restaurant.getId());
            %>
                <div class="space-y-8 pb-12 border-b-2 border-slate-700/50 last:border-0">
                    <div class="glass-card p-8 rounded-3xl flex flex-col md:flex-row justify-between items-start md:items-center gap-6 shadow-xl relative overflow-hidden">
                        <div class="absolute -right-10 -bottom-10 bg-orange-500/10 w-40 h-40 rounded-full blur-2xl pointer-events-none"></div>
                        <div>
                            <div class="flex items-center gap-3 mb-2">
                                <h2 class="text-3xl font-bold tracking-tight"><%= restaurant.getName() %></h2>
                                <span class="bg-green-500/10 text-green-400 border border-green-500/20 text-xs px-2.5 py-1 rounded-md font-bold uppercase tracking-wider">Active</span>
                            </div>
                            <div class="flex items-center gap-4 text-slate-400 font-medium">
                                <span class="flex items-center gap-1.5"><i data-feather="map-pin" class="w-4 h-4 text-orange-500"></i> <%= restaurant.getLocation() %></span>
                                <span class="flex items-center gap-1.5"><i data-feather="clock" class="w-4 h-4 text-orange-500"></i> <%= restaurant.getOperatingHours() %></span>
                            </div>
                        </div>
                        
                        <div class="flex flex-col gap-3 w-full md:w-auto bg-slate-900/50 p-4 rounded-2xl border border-slate-700/50 relative z-10">
                            <p class="text-xs text-slate-400 font-medium uppercase tracking-wider mb-1">Edit Details</p>
                            <form action="${pageContext.request.contextPath}/owner/restaurant" method="post" class="flex items-center gap-2">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="restaurantId" value="<%= restaurant.getId() %>">
                                <div class="relative">
                                    <i data-feather="map-pin" class="absolute left-2.5 top-1/2 transform -translate-y-1/2 text-slate-500 w-3 h-3"></i>
                                    <input type="text" name="location" placeholder="Location" class="bg-slate-800 border border-slate-700 rounded-lg pl-8 pr-3 py-2 text-sm w-36 focus:border-orange-500 text-white" value="<%= restaurant.getLocation() %>" required>
                                </div>
                                <div class="relative">
                                    <i data-feather="clock" class="absolute left-2.5 top-1/2 transform -translate-y-1/2 text-slate-500 w-3 h-3"></i>
                                    <input type="text" name="hours" placeholder="Hours" class="bg-slate-800 border border-slate-700 rounded-lg pl-8 pr-3 py-2 text-sm w-36 focus:border-orange-500 text-white" value="<%= restaurant.getOperatingHours() %>" required>
                                </div>
                                <button type="submit" class="bg-slate-700 hover:bg-orange-500 text-white p-2 rounded-lg transition-colors" title="Save Changes">
                                    <i data-feather="save" class="w-4 h-4"></i>
                                </button>
                            </form>
                            <form action="${pageContext.request.contextPath}/owner/restaurant" method="post">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="restaurantId" value="<%= restaurant.getId() %>">
                                <button type="submit" class="w-full text-red-400 hover:text-white text-xs font-bold bg-red-500/10 hover:bg-red-500 py-2 rounded-lg border border-red-500/20 transition-all flex items-center justify-center gap-2" onclick="return confirm('CRITICAL ACTION: Delete entire restaurant?');">
                                    <i data-feather="alert-triangle" class="w-3 h-3"></i> Delete Restaurant Profile
                                </button>
                            </form>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
                        <!-- Add Table Form -->
                        <div class="lg:col-span-4">
                            <div class="glass-card p-8 rounded-3xl sticky top-8 shadow-xl">
                                <h3 class="text-xl font-bold mb-6 flex items-center gap-2">
                                    <i data-feather="plus-circle" class="text-orange-500"></i> Add New Table
                                </h3>
                                <form action="${pageContext.request.contextPath}/owner/dashboard" method="post" class="space-y-5">
                                    <input type="hidden" name="action" value="addTable">
                                    <input type="hidden" name="restaurantId" value="<%= restaurant.getId() %>">
                                    <div>
                                        <label class="block text-slate-400 text-sm font-medium mb-1.5">Table Name / ID</label>
                                        <input type="text" name="tableNumber" placeholder="e.g. VIP-1 or T-12" class="w-full bg-slate-900/50 border border-slate-700 rounded-xl px-4 py-3 focus:border-orange-500 text-white" required>
                                    </div>
                                    <div>
                                        <label class="block text-slate-400 text-sm font-medium mb-1.5">Seat Capacity</label>
                                        <input type="number" name="capacity" placeholder="Number of seats" class="w-full bg-slate-900/50 border border-slate-700 rounded-xl px-4 py-3 focus:border-orange-500 text-white" required min="1">
                                    </div>
                                    <button type="submit" class="w-full bg-slate-800 hover:bg-orange-500 border border-slate-700 hover:border-orange-500 text-white font-bold py-3.5 rounded-xl transition-all flex items-center justify-center gap-2">
                                        <i data-feather="plus" class="w-4 h-4"></i> Add to Floor Plan
                                    </button>
                                </form>
                            </div>
                        </div>

                        <!-- Floor Plan / Tables -->
                        <div class="lg:col-span-8">
                            <div class="glass-card p-8 rounded-3xl shadow-xl h-full">
                                <div class="flex items-center justify-between mb-8 border-b border-slate-700/50 pb-4">
                                    <h3 class="text-2xl font-bold flex items-center gap-2">
                                        <i data-feather="layout" class="text-orange-500"></i> Floor Plan
                                    </h3>
                                    <div class="flex gap-4 text-sm text-slate-400 font-medium hidden sm:flex">
                                        <span class="flex items-center gap-1.5"><span class="w-2.5 h-2.5 rounded-full bg-green-400"></span> Available</span>
                                        <span class="flex items-center gap-1.5"><span class="w-2.5 h-2.5 rounded-full bg-red-400"></span> Occupied</span>
                                    </div>
                                </div>

                                <div class="grid grid-cols-2 sm:grid-cols-3 gap-5">
                                    <% if (tables != null && !tables.isEmpty()) { 
                                        for (Table t : tables) { 
                                            boolean isAvailable = "AVAILABLE".equals(t.getStatus());
                                            String borderColor = isAvailable ? "border-green-500/30" : "border-red-500/30";
                                            String badgeColor = isAvailable ? "bg-green-500/10 text-green-400" : "bg-red-500/10 text-red-400";
                                    %>
                                        <div class="bg-slate-900/80 border <%= borderColor %> p-5 rounded-2xl flex flex-col items-center justify-center text-center relative group hover:shadow-lg transition-all overflow-hidden">
                                            <!-- Decorative top bar based on status -->
                                            <div class="absolute top-0 left-0 w-full h-1 <%= isAvailable ? "bg-green-500" : "bg-red-500" %>"></div>
                                            
                                            <!-- Capacity Indicator -->
                                            <div class="w-14 h-14 <%= isAvailable ? "bg-green-500/10 border-green-500/20 text-green-400" : "bg-red-500/10 border-red-500/20 text-red-400" %> rounded-full flex items-center justify-center mb-3 border-2">
                                                <div class="flex flex-col items-center leading-tight">
                                                    <i data-feather="users" class="w-4 h-4 mb-0.5"></i>
                                                    <span class="font-bold text-sm"><%= t.getCapacity() %></span>
                                                </div>
                                            </div>
                                            
                                            <p class="text-white font-bold text-lg mb-1"><%= t.getTableNumber() %></p>
                                            <span class="text-[10px] uppercase font-bold tracking-widest px-2.5 py-1 rounded-md mb-4 <%= badgeColor %>">
                                                <%= t.getStatus() %>
                                            </span>
                                            
                                            <form action="${pageContext.request.contextPath}/owner/table" method="post" class="w-full">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="tableId" value="<%= t.getId() %>">
                                                <button type="submit" class="w-full text-xs bg-slate-800 hover:bg-red-500 text-slate-400 hover:text-white py-2 rounded-lg border border-slate-700 hover:border-red-500 transition-all font-medium flex items-center justify-center gap-1" onclick="return confirm('Delete this table?');">
                                                    <i data-feather="trash" class="w-3 h-3"></i> Remove
                                                </button>
                                            </form>
                                        </div>
                                    <% } } else { %>
                                        <div class="col-span-full flex flex-col items-center justify-center py-10 opacity-60">
                                            <i data-feather="layout" class="w-12 h-12 text-slate-600 mb-3"></i>
                                            <p class="text-slate-400 text-base font-medium">Floor plan is empty.</p>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            <% } } else { %>
                <div class="text-center py-20">
                    <i data-feather="compass" class="w-20 h-20 text-slate-700 mx-auto mb-6"></i>
                    <h2 class="text-3xl font-bold mb-3 text-slate-300">No Restaurants Found</h2>
                    <p class="text-slate-500 mb-8 max-w-md mx-auto">You haven't set up any restaurants yet. Add your first restaurant below to start managing tables.</p>
                </div>
            <% } %>

            <!-- Always visible Add Restaurant Form -->
            <div class="glass-card p-10 rounded-3xl max-w-3xl mx-auto shadow-2xl relative overflow-hidden group border border-orange-500/20 bg-slate-800/80 mt-16">
                <div class="absolute -right-20 -top-20 bg-orange-500/10 w-64 h-64 rounded-full blur-3xl group-hover:bg-orange-500/20 transition-all duration-700"></div>
                <div class="flex items-center gap-4 mb-6">
                    <div class="flex items-center justify-center w-14 h-14 bg-orange-500/20 rounded-2xl border border-orange-500/30">
                        <i data-feather="home" class="text-orange-500 w-6 h-6"></i>
                    </div>
                    <div>
                        <h3 class="text-2xl font-bold">Add Another Restaurant</h3>
                        <p class="text-slate-400 text-sm">Expand your business portfolio.</p>
                    </div>
                </div>
                
                <form action="${pageContext.request.contextPath}/owner/dashboard" method="post" class="space-y-5">
                    <input type="hidden" name="action" value="addRestaurant">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                        <div class="md:col-span-2">
                            <label class="block text-sm font-medium text-slate-400 mb-1">Restaurant Name</label>
                            <input type="text" name="name" class="w-full bg-slate-900/80 border border-slate-700/80 rounded-xl px-4 py-3.5 focus:outline-none focus:border-orange-500 text-white" placeholder="The Continental" required>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-slate-400 mb-1">Location Address</label>
                            <input type="text" name="location" class="w-full bg-slate-900/80 border border-slate-700/80 rounded-xl px-4 py-3.5 focus:outline-none focus:border-orange-500 text-white" placeholder="123 Luxury Ave, City" required>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-slate-400 mb-1">Operating Hours</label>
                            <input type="text" name="hours" class="w-full bg-slate-900/80 border border-slate-700/80 rounded-xl px-4 py-3.5 focus:outline-none focus:border-orange-500 text-white" placeholder="e.g. 10:00 AM - 11:00 PM" required>
                        </div>
                    </div>
                    <button type="submit" class="w-full bg-orange-500 hover:bg-orange-600 text-white font-bold py-4 rounded-xl transition-all shadow-[0_0_15px_rgba(249,115,22,0.3)] mt-2">
                        Create Restaurant Profile
                    </button>
                </form>
            </div>

        </div>
    </main>

    <script>
        feather.replace();
    </script>
</body>
</html>
