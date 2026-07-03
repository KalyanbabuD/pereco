class ApiEndpoints {
  static const String baseUrl = 'https://crmextapi.ibizaccounts.in/accumen';
  static const String login = '/Login';
  static const String getDashboardData = '/dashboard/GetDashboardData';
  static const String getLeads = '/leads/GetLeads';
  static const String getLeadById = '/leads/GetLeadById';
  static const String getProposals = '/proposal/GetProposals';
  static const String getReminders = '/reminder/GetReminders';
  static const String getNotes = '/notes/GetNotes';
  static const String getCustomers = '/customers/GetCustomers';
  static const String getCustomerDetails = '/customers/GetCustomerDetails';
  static const String getProposalDetails = '/proposal/GetProposal'; // Append /{id} when using
  static const String getPayments = '/payments/GetPayments';
  static const String getPaymentDetails = '/GetPaymentDetails';
  static const String getProducts = '/products/GetProducts';
  static const String getExpenses = '/expenses/GetExpenses';
  static const String getTodos = '/todo/GetTodos';
  static const String updateTodoStatus = '/todo/UpdateTodoStatus';
  static const String addTodo = '/todo/AddTodo';
  static const String updateTodo = '/todo/UpdateTodo';
  static const String deleteTodo = '/todo/DeleteTodo';
  static const String getStaffDropdown = '/staff/GetStaffDropdown';
}
