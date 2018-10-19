declare module 'react-native-zlib' {


  /** Inflate provided array of bytes. */
  export function inflateBase64(data: string): Promise<string>;

  /** Inflate provided array of bytes. */
  export function inflate(data: number[]): Promise<number[]>;

  /** Deflate provided base64 string. */
  export function deflateBase64(data: string): Promise<string>;

  /** Deflate provided array of bytes. */
  export function deflate(data: number[]): Promise<number[]>;
}
