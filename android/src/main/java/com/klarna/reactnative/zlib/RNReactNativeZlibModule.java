
package com.klarna.reactnative.zlib;

import android.support.annotation.NonNull;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.AssertionException;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableNativeArray;

import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.zip.Deflater;
import java.util.zip.Inflater;

@SuppressWarnings({"unused", "WeakerAccess"})
public class RNReactNativeZlibModule extends ReactContextBaseJavaModule {
    /**
     * Module public name.
     */
    public static final String RNREACT_NATIVE_ZLIB = "RNReactNativeZlib";
    /**
     * Error name for Promise's.
     */
    public static final String ER_FAILURE = "ERROR_FAILED";

    private final ReactApplicationContext reactContext;

    public RNReactNativeZlibModule(final ReactApplicationContext reactContext) {
        super(reactContext);

        this.reactContext = reactContext;
    }

    @Override
    public final String getName() {
        return RNREACT_NATIVE_ZLIB;
    }

    /** Decompress the bytes. */
    @ReactMethod
    public void inflate(@NonNull final ReadableArray data, @NonNull final Promise promise) {
        final WritableArray results = new WritableNativeArray();
        final byte[] buffer = new byte[1024];

        try {
            final byte[] inputBytes = getByteArrayFromInput(data);
            final Inflater inflater = new Inflater();
            inflater.setInput(inputBytes);

            while (!inflater.finished()) {
                final int count = inflater.inflate(buffer);

                for (int i = 0; i < count; i++) {
                    results.pushInt(buffer[i]);
                }
            }
            inflater.end();

            promise.resolve(results);
        } catch (final Throwable ex) {
            promise.reject(ER_FAILURE, ex);
        }
    }

    /** Compress bytes. */
    @ReactMethod
    public void deflate(@NonNull final ReadableArray data, @NonNull final Promise promise) {
        final WritableArray results = Arguments.createArray();
        final byte[] buffer = new byte[1024];

        try {
            final byte[] inputBytes = getByteArrayFromInput(data);
            final Deflater deflater = new Deflater();
            deflater.setInput(inputBytes);
            deflater.finish();

            while (!deflater.finished()) {
                final int count = deflater.deflate(buffer);

                for (int i = 0; i < count; i++) {
                    results.pushInt(buffer[i]);
                }
            }

            promise.resolve(results);
        } catch (final Throwable ex) {
            promise.reject(ER_FAILURE, ex);
        }
    }

    @NonNull
    private byte[] getByteArrayFromInput(@NonNull final ReadableArray input) {
        final int size = input.size();
        final ByteArrayOutputStream output = new ByteArrayOutputStream(size);

        for (int i = 0; i < size; i++) {
            output.write(input.getInt(i));
        }

        return output.toByteArray();
    }

}