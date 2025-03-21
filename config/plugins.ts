export default ({ env }) => ({
  upload: {
    config: {
      provider: '@strapi/provider-upload-aws-s3',
      providerOptions: {
        accessKeyId: env('AWS_ACCESS_KEY_ID'),
        secretAccessKey: env('AWS_ACCESS_KEY_SECRET'),
        region: env('AWS_REGION'),
        params: {
          // Bucket: `strapi5-test-${env('NODE_ENV')}`,
          Bucket: env('AWS_BUCKET'),
          ACL: null
        },
        ObjectOwnership: "BucketOwnerEnforced"
      },
      baseUrl: env('CLOUDFRONT_DOMAIN_NAME')
    },
  },
});