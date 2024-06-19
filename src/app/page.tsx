import Head from 'next/head';
import styles from './styles/Home.module.css';

export default function Home() {

  return (
    <div className={styles.container}>
      <Head>
        <title>Página de Teste DevOps</title>
        <meta name="description" content="Página simples em Next.js para testes DevOps" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>
          Bem-vindo à Página de Teste 1!
        </h1>
        <p className={styles.description}>
          Data e hora atual: {new Date().toLocaleString()}
        </p>
        <p className={styles.description}>
          Variável de Ambiente: - {process.env.NEXT_PUBLIC_NEXT_ENV}
        </p>
      </main>

      <footer className={styles.footer}>
        Feito com ♥ para testes DevOps
      </footer>
    </div>
  );
}
