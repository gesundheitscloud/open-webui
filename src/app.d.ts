// See https://kit.svelte.dev/docs/types#app
// for information about these interfaces
declare global {
	namespace App {
		// interface Error {}
		// interface Locals {}
		// interface PageData {}
		// interface Platform {}
	}
	const envConfig: Config;
}

type Config = {
  DISCLAIMER_TEXT: boolean;
};

export {};
