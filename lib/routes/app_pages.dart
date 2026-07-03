import 'package:get/get.dart';
import '../modules/splash/splash_view.dart';
import '../modules/splash/splash_binding.dart';
import '../modules/auth/login_view.dart';
import '../modules/auth/login_binding.dart';
import '../modules/dashboard/dashboard_view.dart';
import '../modules/dashboard/dashboard_binding.dart';
import '../modules/lead_details/lead_details_view.dart';
import '../modules/lead_details/lead_details_binding.dart';
import '../modules/customer_details/customer_details_view.dart';
import '../modules/customer_details/customer_details_binding.dart';
import '../modules/expenses/expenses_view.dart';
import '../modules/expenses/expenses_binding.dart';
import '../modules/expense_details/expense_details_view.dart';
import '../modules/expense_details/expense_details_binding.dart';
import '../modules/todo/todo_view.dart';
import '../modules/todo/todo_binding.dart';
import '../modules/invoices/invoices_view.dart';
import '../modules/invoices/invoices_binding.dart';
import '../modules/estimations/estimations_view.dart';
import '../modules/estimations/estimations_binding.dart';
import '../modules/proposal/proposal_view.dart';
import '../modules/proposal/proposal_binding.dart';
import '../modules/proposal/proposal_details_view.dart';
import '../modules/payments/payments_view.dart';
import '../modules/payments/payments_binding.dart';
import '../modules/payments/payment_details_view.dart';
import '../modules/payments/payment_details_binding.dart';
import '../modules/products/products_view.dart';
import '../modules/reports/reports_view.dart';
import '../modules/followups/followups_view.dart';
import '../modules/followups/followups_binding.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.LEAD_DETAILS,
      page: () => const LeadDetailsView(),
      binding: LeadDetailsBinding(),
    ),
    GetPage(
      name: Routes.CUSTOMER_DETAILS,
      page: () => const CustomerDetailsView(),
      binding: CustomerDetailsBinding(),
    ),
    GetPage(
      name: Routes.EXPENSES,
      page: () => const ExpensesView(),
      binding: ExpensesBinding(),
    ),
    GetPage(
      name: Routes.EXPENSE_DETAILS,
      page: () => const ExpenseDetailsView(),
      binding: ExpenseDetailsBinding(),
    ),
    GetPage(
      name: Routes.TODO,
      page: () => const TodoView(),
      binding: TodoBinding(),
    ),
    GetPage(
      name: Routes.INVOICES,
      page: () => const InvoicesView(),
      binding: InvoicesBinding(),
    ),
    GetPage(
      name: Routes.ESTIMATIONS,
      page: () => const EstimationsView(),
      binding: EstimationsBinding(),
    ),
    GetPage(
      name: Routes.PROPOSAL,
      page: () => const ProposalView(),
      binding: ProposalBinding(),
    ),
    GetPage(
      name: Routes.PROPOSAL_DETAILS,
      page: () => const ProposalDetailsView(),
      binding: ProposalBinding(),
    ),
    GetPage(
      name: Routes.PAYMENTS,
      page: () => const PaymentsView(),
      binding: PaymentsBinding(),
    ),
    GetPage(
      name: Routes.PAYMENT_DETAILS,
      page: () => const PaymentDetailsView(),
      binding: PaymentDetailsBinding(),
    ),
    GetPage(
      name: Routes.PRODUCTS,
      page: () => const ProductsView(),
    ),
    GetPage(
      name: Routes.REPORTS,
      page: () => const ReportsView(),
    ),
    GetPage(
      name: Routes.FOLLOWUPS,
      page: () => const FollowupsView(),
      binding: FollowupsBinding(),
    ),
  ];
}
