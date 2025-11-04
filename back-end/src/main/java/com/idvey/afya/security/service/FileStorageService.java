package com.idvey.afya.security.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@Service
@Slf4j
public class FileStorageService {

	private static final String UPLOAD_DIR = "uploads/profiles/";

	private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

	/**
	 * Save profile image and return the URL
	 * @param file The image file to save
	 * @param userId The user's ID
	 * @return The URL path to the saved image
	 * @throws IOException if file operations fail
	 */
	public String saveProfileImage(MultipartFile file, String userId) throws IOException {
		validateFile(file);

		// Create directory if it doesn't exist
		Path uploadPath = Paths.get(UPLOAD_DIR);
		if (!Files.exists(uploadPath)) {
			Files.createDirectories(uploadPath);
			log.info("Created upload directory: {}", uploadPath);
		}

		// Generate unique filename
		String extension = getFileExtension(file.getOriginalFilename());
		String filename = userId + "_" + System.currentTimeMillis() + extension;
		Path filePath = uploadPath.resolve(filename);

		// Save file
		Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
		log.info("Profile image saved: {}", filePath);

		// Return URL path
		return "/uploads/profiles/" + filename;
	}

	/**
	 * Delete profile image from file system
	 * @param imageUrl The URL of the image to delete
	 * @return true if deleted successfully, false otherwise
	 */
	public boolean deleteProfileImage(String imageUrl) {
		if (imageUrl == null || imageUrl.isEmpty()) {
			log.warn("Attempted to delete null or empty image URL");
			return false;
		}

		try {
			// Extract filename from URL (e.g., "/uploads/profiles/filename.jpg" ->
			// "filename.jpg")
			String filename = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
			Path filePath = Paths.get(UPLOAD_DIR + filename);

			if (Files.exists(filePath)) {
				Files.delete(filePath);
				log.info("Deleted profile image: {}", filePath);
				return true;
			}
			else {
				log.warn("Profile image not found: {}", filePath);
				return false;
			}
		}
		catch (IOException e) {
			log.error("Error deleting profile image: {}", e.getMessage(), e);
			return false;
		}
		catch (Exception e) {
			log.error("Unexpected error deleting profile image: {}", e.getMessage(), e);
			return false;
		}
	}

	/**
	 * Validate uploaded file
	 * @param file The file to validate
	 * @throws IllegalArgumentException if validation fails
	 */
	private void validateFile(MultipartFile file) {
		if (file.isEmpty()) {
			throw new IllegalArgumentException("File is empty");
		}

		// Validate file type
		String contentType = file.getContentType();
		if (contentType == null || !contentType.startsWith("image/")) {
			throw new IllegalArgumentException("Only image files are allowed");
		}

		// Validate file size
		if (file.getSize() > MAX_FILE_SIZE) {
			throw new IllegalArgumentException("File size must not exceed 5MB");
		}
	}

	/**
	 * Get file extension from filename
	 * @param filename The original filename
	 * @return The file extension (e.g., ".jpg")
	 */
	private String getFileExtension(String filename) {
		if (filename != null && filename.contains(".")) {
			return filename.substring(filename.lastIndexOf("."));
		}
		return ".jpg"; // Default extension
	}

	/**
	 * Check if a file exists
	 * @param imageUrl The URL of the image
	 * @return true if file exists, false otherwise
	 */
	public boolean fileExists(String imageUrl) {
		if (imageUrl == null || imageUrl.isEmpty()) {
			return false;
		}

		try {
			String filename = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
			Path filePath = Paths.get(UPLOAD_DIR + filename);
			return Files.exists(filePath);
		}
		catch (Exception e) {
			log.error("Error checking file existence: {}", e.getMessage());
			return false;
		}
	}

}