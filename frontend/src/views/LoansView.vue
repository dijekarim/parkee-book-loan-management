<script setup lang="ts">
import { ref, onMounted } from "vue";
import api from "@/services/api";

interface Borrower {
  id: number;
  name: string;
  id_card_number: string;
}

interface Book {
  id: number;
  title: string;
  stock: number;
}

interface Loan {
  id: number;
  borrower: Borrower;
  book: Book;
  borrow_date: string;
  return_date: string;
  returned_at: string | null;
  status: "Active" | "Overdue" | "Returned";
}

const borrowers = ref<Borrower[]>([]);
const books = ref<Book[]>([]);
const loans = ref<Loan[]>([]);
const pagination = ref<any>(null);
const currentPage = ref(1);

const selectedBorrower = ref<number | null>(null);
const selectedBook = ref<number | null>(null);
const returnDate = ref<string>("");

const error = ref<string | null>(null);
const success = ref<string | null>(null);

const today = new Date().toISOString().split("T")[0];
const maxReturnDate = new Date();
maxReturnDate.setDate(maxReturnDate.getDate() + 30);
const maxReturnDateStr = maxReturnDate.toISOString().split("T")[0];

const fetchData = async (page = 1) => {
  const borrowersRes = await api.get("/borrowers");
  borrowers.value = borrowersRes.data.data;

  const booksRes = await api.get("/books");
  books.value = booksRes.data.data;

  const loansRes = await api.get("/loans", { params: { page } });
  loans.value = loansRes.data.data;
  pagination.value = loansRes.data.pagination;
  currentPage.value = page;
};

const createLoan = async () => {
  error.value = null;
  success.value = null;

  if (!selectedBorrower.value || !selectedBook.value || !returnDate.value) {
    error.value = "Please select borrower, book, and return date.";
    return;
  }

  if (returnDate.value < today) {
    error.value = "Return date cannot be before today.";
    return;
  }
  if (returnDate.value > maxReturnDateStr) {
    error.value = "Return date cannot be more than 30 days from today.";
    return;
  }

  try {
    await api.post("/loans", {
      borrower_id: selectedBorrower.value,
      book_id: selectedBook.value,
      borrow_date: today,
      return_date: returnDate.value,
    });

    success.value = "Loan created successfully ✅";
    selectedBorrower.value = null;
    selectedBook.value = null;
    returnDate.value = "";
    fetchData(currentPage.value);
  } catch (e: any) {
    error.value = e.response?.data?.error || "Failed to create loan ❌";
  }
};

const returnLoan = async (loanId: number) => {
  try {
    await api.patch(`/loans/${loanId}/return`);
    success.value = "Book returned successfully ✅";
    fetchData(currentPage.value);
  } catch (e: any) {
    error.value = e.response?.data?.error || "Failed to return loan ❌";
  }
};

onMounted(() => fetchData(1));
</script>

<template>
  <div>
    <h1 class="text-2xl font-bold text-gray-800 mb-6">📑 Loans</h1>

    <div v-if="error" class="bg-red-100 text-red-700 p-3 rounded mb-4">
      {{ error }}
    </div>
    <div v-if="success" class="bg-green-100 text-green-700 p-3 rounded mb-4">
      {{ success }}
    </div>

    <!-- Loan Form -->
    <form @submit.prevent="createLoan" class="flex flex-wrap gap-3 mb-8">
      <select v-model="selectedBorrower" class="border rounded px-3 py-2 flex-1">
        <option disabled value="">-- Select Borrower --</option>
        <option v-for="b in borrowers" :key="b.id" :value="b.id">
          {{ b.name }} ({{ b.id_card_number }})
        </option>
      </select>

      <select v-model="selectedBook" class="border rounded px-3 py-2 flex-1">
        <option disabled value="">-- Select Book --</option>
        <option
          v-for="bk in books"
          :key="bk.id"
          :value="bk.id"
          :disabled="bk.stock <= 0"
        >
          {{ bk.title }} (Stock: {{ bk.stock }})
        </option>
      </select>

      <input
        type="date"
        v-model="returnDate"
        class="border rounded px-3 py-2"
        :min="today"
        :max="maxReturnDateStr"
      />

      <button
        class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
      >
        Create Loan
      </button>
    </form>

    <!-- Loans Table -->
    <div class="overflow-x-auto bg-white shadow rounded-lg">
      <table class="min-w-full text-sm text-left">
        <thead class="bg-gray-100 text-gray-700 uppercase text-xs">
          <tr>
            <th class="px-4 py-2">Borrower</th>
            <th class="px-4 py-2">Book</th>
            <th class="px-4 py-2">Start Date</th>
            <th class="px-4 py-2">Return Date</th>
            <th class="px-4 py-2">Status</th>
            <th class="px-4 py-2"></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="loan in loans" :key="loan.id" class="border-t hover:bg-gray-50">
            <td class="px-4 py-2">{{ loan.borrower.name }}</td>
            <td class="px-4 py-2">{{ loan.book.title }}</td>
            <td class="px-4 py-2">{{ loan.borrow_date }}</td>
            <td class="px-4 py-2">{{ loan.return_date }}</td>
            <td class="px-4 py-2">
              <span
                v-if="loan.status === 'Active'"
                class="px-2 py-1 bg-green-100 text-green-700 rounded text-xs"
              >Active</span>
              <span
                v-else-if="loan.status === 'Overdue'"
                class="px-2 py-1 bg-red-100 text-red-700 rounded text-xs"
              >Overdue</span>
              <span
                v-else
                class="px-2 py-1 bg-gray-200 text-gray-700 rounded text-xs"
              >Returned</span>
            </td>
            <td class="px-4 py-2">
              <button
                v-if="loan.status === 'Active' || loan.status === 'Overdue'"
                @click="returnLoan(loan.id)"
                class="bg-indigo-600 text-white px-3 py-1 rounded hover:bg-indigo-700"
              >
                Mark Returned
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination Controls -->
    <div v-if="pagination" class="flex justify-between items-center mt-6">
      <button
        :disabled="!pagination.prev"
        @click="fetchData(pagination.prev || 1)"
        class="px-4 py-2 rounded bg-gray-200 text-gray-600 hover:bg-gray-300 disabled:opacity-50"
      >
        Previous
      </button>

      <span class="text-sm text-gray-600">
        Page {{ pagination.page }} of {{ pagination.last }}
      </span>

      <button
        :disabled="!pagination.next"
        @click="fetchData(pagination.next || pagination.last)"
        class="px-4 py-2 rounded bg-gray-200 text-gray-600 hover:bg-gray-300 disabled:opacity-50"
      >
        Next
      </button>
    </div>
  </div>
</template>