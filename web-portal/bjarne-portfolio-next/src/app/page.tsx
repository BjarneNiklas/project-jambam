import { redirect } from 'next/navigation';

export default function RootPage() {
  // Redirect zur deutschen Version
  redirect('/de');
}
